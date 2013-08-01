//
//  BluetoothController.m
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "BluetoothController.h"
#import "MatchmakingServer.h"
#import "MatchmakingClient.h"

@interface BluetoothController () <MatchmakingClientDelegate, MatchmakingServerDelegate>

@property (nonatomic, strong) MatchmakingServer* matchmakingServer;
@property (nonatomic, strong) MatchmakingClient* matchmakingClient;
@property (nonatomic, assign) BOOL isHost;

@end

@implementation BluetoothController

- (void)loadRummyInstance:(Rummy *)rummy withCardTableView:(CardTableView *)cardTableView {
    
    self.isHost = YES;
    
    NSString* sessionId = NSLocalizedString(@"Rummy!", nil);
    if (self.isHost) {
        _matchmakingServer = [[MatchmakingServer alloc] init];
		_matchmakingServer.maxClients = 4;
		[_matchmakingServer startAcceptingConnectionsForSessionID:sessionId];
        
    }
    else {
        _matchmakingClient = [[MatchmakingClient alloc] init];
		[_matchmakingClient startSearchingForServersWithSessionID:sessionId];
        _matchmakingClient.delegate = self;
    }
}

- (void)start {
    
}

// MARK: private

// MARK: MatchmakingClientDelegate

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

// MARK: MatchmakingServerDelegate

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
	[self.tableView reloadData];
}


@end
