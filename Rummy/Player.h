//
//  Player.h
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;

@interface Player : NSObject

@property (nonatomic, strong) NSNumber* playerId;
@property (nonatomic, strong) NSString* name;

- (void)receive_card:(Card*)card;
- (void)dump_cards;

@end
