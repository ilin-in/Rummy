//
//  Rummy.h
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "ControllerProtocol.h"

typedef enum {
    EQUAL, LESS, BIGGER, FAIL
} compare_result_t;

@class Deck;
@class CardTableView;

@interface Rummy : NSObject

@property (nonatomic, strong) NSNumber* gameId;
@property (nonatomic, strong) NSNumber* currentUserId;
@property (nonatomic, strong) NSArray* players;
@property (nonatomic, strong) NSArray* secondRoundPlayers;
@property (nonatomic, strong) Deck* deck;
@property (nonatomic, strong) NSArray* actions;
@property (nonatomic, strong) id<ControllerProtocol> controller;
@property (nonatomic, strong) CardTableView* cardTableView;
@property (nonatomic, assign) BOOL isRound2State;

+ (Rummy*)sharedInstance;
+ (compare_result_t)compareCard:(Card*)card1 withCard:(Card*)card2;
+ (void)step;

- (void)step;

@end
