//
//  Action.h
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RECIEVE_PLAYER_CARD,
    NEW_PLAYER,
    PLAYER_PUT_CARD,
    PLAYER_WIN_ROUND,
    ROUND_2,
    RECIEVE_INITIAL_CARDS,
    PLAYER_FAILED_GAME,
    PLAYER_WON_GAME,
} action_t;

@interface Action : NSObject

@property (nonatomic, assign) action_t type;
@property (nonatomic, strong) NSDictionary* data;

@end
