//
//  Deck.h
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;

@interface Deck : NSObject

- (id)initWithJokers:(BOOL)w_jokers full:(BOOL)full;

- (void)dump_deck;
- (void)shuffle;
- (Card*)pop_top;
- (void)add_card:(Card*)card;
- (NSInteger)cards_left;

@end
