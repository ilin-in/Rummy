//
//  Rummy.m
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "Rummy.h"
#import "CardTableView.h"
#import "Action.h"

@implementation Rummy

+ (Rummy*)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (compare_result_t)compareCard:(Card *)card1 withCard:(Card *)card2 {
    if (!card1 && card2) {
        return LESS;
    }
    else if (!card2 && card1) {
        return BIGGER;
    }
    else if (!card1 && !card2) {
        return FAIL;
    }
    NSUInteger card1Value = [self cardNumberValue:card1.number];
    NSUInteger card2Value = [self cardNumberValue:card2.number];
    
    if (card1Value > card2Value) {
        return BIGGER;
    }
    else if (card1Value < card2Value) {
        return LESS;
    }
    else {
        return EQUAL;
    }
}

// Remote -> action -> step
// Computer -> action - > step
// User -> action -> step

// Actions
//    - new player with name
//    - player put card
//    - player win round
//    - round 2 between players
//    - player recieve initial cards
//    - player failed game
//    - player won game
+ (void)step {
    // Doing actions
    [[Rummy sharedInstance] step];
}

- (void)step {
    for (int i = 0; i < self.actions.count; i++) {
        Action* action = self.actions[i];
        if (action.type == NEW_PLAYER) {
//            Player* player = action.data[ACTION_OBJECT];
//            [self.cardTableView newPlayer:player];
        }
        else if (action.type == PUT_DECK) {
            [self.cardTableView putDeck:self.deck];
        }
        else if (action.type == RECEIVE_INITIAL_CARDS) {
            Player* player = action.data[ACTION_OBJECT];
            [self.cardTableView receiveInitialCards:player];
        }
        else if (action.type == PLAYER_PUT_CARD) {
            Player* player = action.data[ACTION_OBJECT];
            NSNumber* level = action.data[ACTION_OBJECT2];
            [self.cardTableView playerPutCard:player withLevel:level.integerValue];
        }
        else if (action.type == PLAYER_WON_ROUND) {
            Player* player = action.data[ACTION_OBJECT];
            [self.cardTableView playerWonRound:player];
        }
        else if (action.type == PLAYER_WON_GAME) {
            Player* player = action.data[ACTION_OBJECT];
            [self.cardTableView playerWonGame:player];
        }
        else if (action.type == PLAYER_FAILED_GAME) {
            Player* player = action.data[ACTION_OBJECT];
            [self.cardTableView playerFailedGame:player];
        }
    }
    self.actions = @[];
}

// MARK: private

- (NSArray *)actions {
    if (!_actions) {
        return @[];
    }
    return _actions;
}

+ (NSUInteger)cardNumberValue:(number_t)number {
    if (number == JOKER) {
        return 15;
    }
    else if (number == ACE) {
        return 14;
    }
    else {
        return number;
    }
}

@end
