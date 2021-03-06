//
//  Player.h
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;
@class Deck;

@interface Player : NSObject

@property (nonatomic, strong) NSNumber* playerId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) BOOL isLocalPlayer;
@property (nonatomic, strong) Deck* deck;
@property (nonatomic, assign) NSUInteger topCardsOnTheTable;

- (void)receive_card:(Card*)card;
- (void)dump_cards;

@end
