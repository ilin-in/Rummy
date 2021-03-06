//
//  Action.h
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const ACTION_OBJECT;
extern NSString* const ACTION_OBJECT2;

typedef enum {
    INIT_PLAYERS,
    PUT_DECK,
    PLAYER_PUT_CARD,
    PLAYER_WON_ROUND,
    RECEIVE_INITIAL_CARDS,
    PLAYER_FAILED_GAME,
    PLAYER_WON_GAME,
    PLAYERS_DRAW_GAME,
    PLAYERS_REFRESH,
} action_t;

@interface Action : NSObject

@property (nonatomic, assign) action_t type;
@property (nonatomic, strong) NSDictionary* data;

@end
