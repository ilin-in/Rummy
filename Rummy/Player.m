//
//  Player.m
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "Player.h"
#import "Deck.h"

@interface Player ()

@property (nonatomic, strong) NSArray* tableCards;

@end

@implementation Player

- (id)init {
    if ((self = [super init])) {
        self.deck = [[Deck alloc] initWithJokers:YES full:NO];
    }
    return self;
}

- (void)dump_cards {
    [self.deck dump_deck];
}

- (void)receive_card:(Card*)card {
    [self.deck add_card:card];
}

@end
