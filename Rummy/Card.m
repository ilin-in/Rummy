//
//  Card.m
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSString *)description {
    NSString* name = @"";
    BOOL isJoker = NO;
    
    switch (self.number) {
        case JOKER:
            isJoker = YES;
            break;
        case ACE:
            name = [name stringByAppendingString:@"A"];
            break;
        case JACK:
            name = [name stringByAppendingString:@"J"];
            break;
        case QUEEN:
            name = [name stringByAppendingString:@"Q"];
            break;
        case KING:
            name = [name stringByAppendingString:@"K"];
            break;
            
        default:
            name = [name stringByAppendingFormat:@"%d", self.number];
            break;
    }
    
    switch (self.suit) {
        case NO_SUIT:
            isJoker = YES;
            break;
        case HEARTS:
            name = [name stringByAppendingString:@" H"];
            break;
        case DIAMONDS:
            name = [name stringByAppendingString:@" D"];
            break;
        case CLUBS:
            name = [name stringByAppendingString:@" C"];
            break;
        case SPADES:
            name = [name stringByAppendingString:@" S"];
            break;
            
        default:
            break;
    }
    if (isJoker) {
        name = @"JOK";
    }
    
    return name;
}

@end
