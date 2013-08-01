//
//  MatchingmakingClient.m
//  Rummy
//
//  Created by Ilya Ilin on 8/1/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "MatchmakingClient.h"
#import <GameKit/GameKit.h>

@interface MatchmakingClient () <GKSessionDelegate>

@property (nonatomic, strong) NSString* serverPeerID;

@end

@implementation MatchmakingClient

- (id)init
{
	if ((self = [super init])) {
		_clientState = ClientStateIdle;
	}
	return self;
}

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID
{
    if (_clientState == ClientStateIdle)
	{
		_clientState = ClientStateSearchingForServers;
        _availableServers = [NSMutableArray arrayWithCapacity:10];
        
        _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
        _session.delegate = self;
        _session.available = YES;
    }
}

- (NSArray *)availableServers
{
	return _availableServers;
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	[self msg:[NSString stringWithFormat:@"MatchmakingClient: peer %@ changed state %d", peerID, state]];
    switch (state)
	{
            // The client has discovered a new server.
		case GKPeerStateAvailable:
            if (_clientState == ClientStateSearchingForServers)
			{
				if (![_availableServers containsObject:peerID])
				{
					[_availableServers addObject:peerID];
					[self.delegate matchmakingClient:self serverBecameAvailable:peerID];
				}
			}
			break;
            
            // The client sees that a server goes away.
		case GKPeerStateUnavailable:
            if (_clientState == ClientStateSearchingForServers)
			{
				if ([_availableServers containsObject:peerID])
				{
					[_availableServers removeObject:peerID];
					[self.delegate matchmakingClient:self serverBecameUnavailable:peerID];
				}
			}
			break;
            
		case GKPeerStateConnected:
			break;
            
		case GKPeerStateDisconnected:
			break;
            
		case GKPeerStateConnecting:
			break;
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	[self msg:[NSString stringWithFormat:@"MatchmakingClient: connection request from peer %@", peerID]];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
	[self msg:[NSString stringWithFormat:@"MatchmakingClient: connection with peer %@ failed %@", peerID, error]];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
	[self msg:[NSString stringWithFormat:@"MatchmakingClient: session failed %@", error]];
}

// MARK: private

- (void)msg:(NSString*)title {
    [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

// MARK:

- (NSUInteger)availableServerCount
{
	return [_availableServers count];
}

- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index
{
	return [_availableServers objectAtIndex:index];
}

- (NSString *)displayNameForPeerID:(NSString *)peerID
{
	return [_session displayNameForPeer:peerID];
}

- (void)connectToServerWithPeerID:(NSString *)peerID
{
	NSAssert(_clientState == ClientStateSearchingForServers, @"Wrong state");
    
	_clientState = ClientStateConnecting;
	_serverPeerID = peerID;
	[_session connectToPeer:peerID withTimeout:_session.disconnectTimeout];
}

@end
