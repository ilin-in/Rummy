//
//  CardView.m
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "CardView.h"
#import "Card.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    BIG, MEDIUM, SMALL
} suit_sizes_t;

NSString* const FONT_CARD_CHARACTERS = @"Card Characters";

@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadView];
    }
    return self;
}

- (void)loadView {
    self.backgroundColor = [UIColor clearColor];
}

static UIFont* cardCharacters6_5 = nil;
static UIFont* cardCharacters15 = nil;

+ (void)initialize {
    if (self == [CardView class]) {
        cardCharacters6_5 = [UIFont fontWithName:FONT_CARD_CHARACTERS size:6.5f];
        cardCharacters15 = [UIFont fontWithName:FONT_CARD_CHARACTERS size:15.f];
    }
}

- (void)setCard:(Card *)card {
    if (card.number == JOKER) {
        card.suit = NO_SUIT;
    }
    _card = card;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!self.card) {
        UIImage* cardBack = [UIImage imageNamed:@"cardBack"];
        CGContextDrawImage(context, rect, cardBack.CGImage);
        return;
    }
    
    
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, HEX_COLOR(0xd7d7d7).CGColor);
    CGContextSetLineWidth(context, 2.f);
    
    // Border
    {
        CGContextBeginPath(context);
        CGContextSaveGState(context);
        
        rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
        CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
        float radius = 7.5f;
        CGContextScaleCTM(context, radius, radius);
        float fw = CGRectGetWidth(rect) / radius;
        float fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
        
        CGContextClosePath(context);
        CGContextRestoreGState(context);
        
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    // Suit color
    switch (self.card.suit) {
        case HEARTS:
        case DIAMONDS:
            [[UIColor redColor] set];
            break;
        case CLUBS:
        case SPADES:
        case NO_SUIT:
            [[UIColor blackColor] set];
            break;
            
        default:
            break;
    }
    
    // Title
    {
        static CGFloat titleOffsetY = 4.0f;
        switch (self.card.number) {
            case JOKER:
                [self drawCardTitle:@"JOKER" vertically:YES withFont:cardCharacters6_5 rect1:CGRectMake(7.f, titleOffsetY, 7.f, 100.f) rect2:CGRectMake(self.frame.size.width - 13.f, titleOffsetY, 7.f, 100.f) context:context];
                break;
            case ACE:
                [self drawCardTitle:@"A" vertically:NO withFont:cardCharacters15 rect1:CGRectMake(5.5f, titleOffsetY, 7.f, 20.f) rect2:CGRectMake(self.frame.size.width - 15.f, titleOffsetY, 7.f, 20.f) context:context];
                break;
            case TWO:
            case THREE:
            case FOUR:
            case FIVE:
            case SIX:
            case SEVEN:
            case EIGHT:
            case NINE:
            case TEN:
                [self drawCardTitle:@(self.card.number).stringValue vertically:NO withFont:cardCharacters15 rect1:CGRectMake(4.5f, titleOffsetY, 20.f, 20.f) rect2:CGRectMake(self.frame.size.width - 21.f, titleOffsetY, 20.f, 20.f) context:context];
                break;
            case JACK:
                [self drawCardTitle:@"J" vertically:NO withFont:cardCharacters15 rect1:CGRectMake(5.5f, titleOffsetY, 7.f, 20.f) rect2:CGRectMake(self.frame.size.width - 15.f, titleOffsetY, 7.f, 20.f) context:context];
                break;
            case QUEEN:
                [self drawCardTitle:@"Q" vertically:NO withFont:cardCharacters15 rect1:CGRectMake(5.5f, titleOffsetY, 7.f, 20.f) rect2:CGRectMake(self.frame.size.width - 15.f, titleOffsetY, 7.f, 20.f) context:context];
                break;
            case KING:
                [self drawCardTitle:@"K" vertically:NO withFont:cardCharacters15 rect1:CGRectMake(5.5f, titleOffsetY, 7.f, 20.f) rect2:CGRectMake(self.frame.size.width - 15.f, titleOffsetY, 7.f, 20.f) context:context];
                break;
                
            default:
                break;
        }
        
        UIImage* suitMediumImg = [self imageForSuit:self.card.suit withSize:MEDIUM];
        if (suitMediumImg) {
            [self drawTitleImage:suitMediumImg point1:CGPointMake(3.5f, 18.f + titleOffsetY) point2:CGPointMake(self.frame.size.width - suitMediumImg.size.width - 3.5f, 25.0f) context:context];
        }
    }
    
    // Image
    {
        if (self.card.number == JOKER) {
            [[UIImage imageNamed:@"joker"] drawAtPoint:CGPointMake(21.f, 20.f)];
        }
        else if (self.card.number == ACE) {
            UIImage* suitBigImg = [self imageForSuit:self.card.suit withSize:BIG];
            if (suitBigImg) {
                [suitBigImg drawAtPoint:CGPointMake(20.f, 30.f)];
            }
        }
        else if (self.card.number == TWO) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(30.5f, 25.f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(30.5f, 27.0f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == THREE) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(31.5f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(31.f, 43.f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(30.8f, 23.5f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == FOUR) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(21.5f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 22.5f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(22.5f, 24.f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 24.f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == FIVE) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(22.5f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(32.f, 41.f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(22.5f, 24.f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 24.f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == SIX) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(21.5f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(21.5f, 40.5f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 40.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(22.5f, 24.f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 24.f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == SEVEN) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(21.5f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 22.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(31.f, 30.f)];
            [suitSmallImg drawAtPoint:CGPointMake(31.f, 41.5f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(31.f, 31.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(22.5f, 24.f)];
            [suitSmallImg drawAtPoint:CGPointMake(40.f, 24.f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == EIGHT) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(20.5f, 18.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 18.f)];
            [suitSmallImg drawAtPoint:CGPointMake(20.5f, 35.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 35.5f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(20.f, 35.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 35.f)];
            [suitSmallImg drawAtPoint:CGPointMake(20.f, 20.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 20.f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == NINE) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(20.5f, 18.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 18.f)];
            [suitSmallImg drawAtPoint:CGPointMake(20.5f, 35.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 35.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(30.5f, 42.5f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(20.f, 35.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 35.f)];
            [suitSmallImg drawAtPoint:CGPointMake(20.f, 20.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 20.f)];
            
            CGContextRestoreGState(context);
        }
        else if (self.card.number == TEN) {
            UIImage* suitSmallImg = [self imageForSuit:self.card.suit withSize:SMALL];
            [suitSmallImg drawAtPoint:CGPointMake(20.5f, 18.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 18.f)];
            [suitSmallImg drawAtPoint:CGPointMake(20.5f, 35.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 35.5f)];
            [suitSmallImg drawAtPoint:CGPointMake(30.5f, 25.f)];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            
            [suitSmallImg drawAtPoint:CGPointMake(20.f, 35.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 35.f)];
            [suitSmallImg drawAtPoint:CGPointMake(20.f, 20.f)];
            [suitSmallImg drawAtPoint:CGPointMake(41.f, 20.f)];
            [suitSmallImg drawAtPoint:CGPointMake(30.5f, 26.5f)];
            
            CGContextRestoreGState(context);
        }
        
        else if (self.card.number == JACK) {
            [[UIImage imageNamed:@"jack"] drawAtPoint:CGPointMake(23.5f, 27.f)];
        }
        else if (self.card.number == QUEEN) {
            [[UIImage imageNamed:@"queen"] drawAtPoint:CGPointMake(20.5f, 19.f)];
        }
        else if (self.card.number == KING) {
            [[UIImage imageNamed:@"king"] drawAtPoint:CGPointMake(23.f, 24.f)];
        }
    }
}

// MARK:

- (UIImage*)imageForSuit:(suit_t)suit withSize:(suit_sizes_t)size {
    NSString* prefix = nil;
    switch (suit) {
        case HEARTS:
            prefix = @"hearts";
            break;
        case DIAMONDS:
            prefix = @"diamonds";
            break;
        case CLUBS:
            prefix = @"clubs";
            break;
        case SPADES:
            prefix = @"spades";
            break;
        case NO_SUIT:
            break;
            
        default:
            break;
    }
    
    NSString* suffix = nil;
    switch (size) {
        case BIG:
            suffix = @"Big";
            break;
        case MEDIUM:
            suffix = @"Medium";
            break;
        case SMALL:
            suffix = @"Small";
            break;
            
        default:
            break;
    }
    
    if (!suffix || !prefix) {
        return nil;
    }
    
    return [UIImage imageNamed:[prefix stringByAppendingString:suffix]];
}

// MARK: __draw

- (void)drawCardTitle:(NSString*)title vertically:(BOOL)vertically withFont:(UIFont*)font rect1:(CGRect)rect1 rect2:(CGRect)rect2 context:(CGContextRef)context {
    [title drawInRect:rect1 withFont:font lineBreakMode:vertically ? NSLineBreakByClipping : NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];

    // invert title
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    [title drawInRect:rect2 withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    
    CGContextRestoreGState(context);
}

- (void)drawTitleImage:(UIImage*)image point1:(CGPoint)point1 point2:(CGPoint)point2 context:(CGContextRef)context {
    [image drawAtPoint:point1];
    
    // invert title    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    [image drawAtPoint:point2];
    
    CGContextRestoreGState(context);
}


@end
