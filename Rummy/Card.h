//
//  Card.h
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NO_SUIT = 0,
    HEARTS,
    CLUBS,
    DIAMONDS,
    SPADES
} suit_t;

typedef enum
{
    JOKER = 0,
    ACE,
    TWO,
    THREE,
    FOUR,
    FIVE,
    SIX,
    SEVEN,
    EIGHT,
    NINE,
    TEN,
    JACK,
    QUEEN,
    KING
} number_t;

@interface Card : NSObject

@property (nonatomic, assign) NSUInteger cardId;
@property (nonatomic, assign) suit_t suit;
@property (nonatomic, assign) number_t number;

@end
