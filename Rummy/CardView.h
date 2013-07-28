//
//  CardView.h
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CARD_SIZE   { 70.f, 95.f }

extern NSString* const FONT_CARD_CHARACTERS;

@class Card;

@interface CardView : UIView

@property (nonatomic, strong) Card* card;



@end
