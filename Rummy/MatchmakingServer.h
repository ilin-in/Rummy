//
//  MatchmakingServer.h
//  Rummy
//
//  Created by Ilya Ilin on 8/1/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GKSession;

typedef enum
{
	ServerStateIdle,
	ServerStateAcceptingConnections,
	ServerStateIgnoringNewConnections,
}
ServerState;

@protocol MatchmakingServerDelegate;

@interface MatchmakingServer : NSObject

@property (nonatomic, assign) ServerState serverState;
@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong, readonly) NSMutableArray *connectedClients;
@property (nonatomic, strong, readonly) GKSession *session;
@property (nonatomic, assign) id<MatchmakingServerDelegate> delegate;

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID;

- (NSUInteger)connectedClientCount;
- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index;
- (NSString *)displayNameForPeerID:(NSString *)peerID;

@end

@protocol MatchmakingServerDelegate <NSObject>

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID;
- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID;

@end
