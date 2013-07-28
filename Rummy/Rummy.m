//
//  Rummy.m
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "Rummy.h"

@implementation Rummy

+ (id)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (compare_result_t)compareCard:(Card *)card1 withCard:(Card *)card2 {
    if (!card1 || !card2) {
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
//    - recieve player card
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
