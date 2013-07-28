//
//  Deck.m
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "Deck.h"
#import "Card.h"  

#define DECK_MAX_CARDS    54

@interface Deck ()

@property (nonatomic, strong) NSArray* cards;

@end

@implementation Deck

- (id)initWithJokers:(BOOL)w_jokers full:(BOOL)full {
    if ((self = [super init])) {
        if (full) {
            int cardsCount = w_jokers ? 54 : 52;
            NSMutableArray* cardsM = [NSMutableArray arrayWithArray:self.cards];
            for(int i = 0; i < cardsCount; i++) {
                [cardsM addObject:[self createCardForIndex:i withJokers:w_jokers]];
            }
            self.cards = cardsM;
            [self shuffle];
        }
    }
    return self;
}

- (Card*)createCardForIndex:(NSUInteger)index withJokers:(BOOL)w_jokers {
    if (index > DECK_MAX_CARDS) {
        return nil;
    }
    Card* card = [[Card alloc] init];
    if (w_jokers && (index == 0 || index == 1)) {
        card.suit = NO_SUIT;
        card.number = JOKER;
        return card;
    }
    
    int firstSuitIndex = w_jokers ? 2 : 0;
    suit_t suit = ((index - firstSuitIndex) / 13) + 1;
    number_t number = ((index - firstSuitIndex) % 13) + 1;
    card.suit = suit;
    card.number = number;
    
    return card;
}

- (void)shuffle {
    NSMutableArray* cardsM = [NSMutableArray arrayWithArray:self.cards];
    NSUInteger count = [cardsM count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [cardsM exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    self.cards = cardsM;
}

- (Card*)pop_top {
    if (!self.cards.count) {
        return nil;
    }
    Card* top_card = self.cards[0];
    
    NSMutableArray* cardsM = [NSMutableArray arrayWithArray:self.cards];
    [cardsM removeObjectAtIndex:0];
    self.cards = cardsM;
    
    return top_card;
}

- (void)dump_deck {
    NSMutableString* dump = [[NSMutableString alloc] init];
    for (Card* card in self.cards) {
        [dump appendFormat:@" {%@},", card];
    }
    NSLog(@"%@", dump);
}

- (NSInteger)cards_left {
    return self.cards.count;
}

- (void)add_card:(Card *)card {
    NSMutableArray* cardsM = [NSMutableArray arrayWithArray:self.cards];
    [cardsM addObject:card];
    self.cards = cardsM;
}

@end
