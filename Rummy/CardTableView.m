//
//  CardTableView.m
//  Rummy
//
//  Created by Ilya Ilin on 7/27/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "CardTableView.h"
#import "CardView.h"
#import "Player.h"
#import "Rummy.h"
#import "Card.h"

#define MAX_PLAYERS         4
#define TABLE_TOP_OFFSET    50

typedef enum {
    TOP_LEFT, TOP_RIGHT, BOTTOM_RIGHT, BOTTOM_LEFT
} table_pos_t;

@interface CardTableView ()

@property (nonatomic, strong) UILabel* lblTimer;
@property (nonatomic, strong) Rummy* rummy;
@property (nonatomic, strong) NSMutableArray* players;

@end

// Actions
//    - recieve player card (for user)
//    - new player with name
//    - player put card
//    - player win round
//    - round 2 between players
//    - player recieve initial cards
//    - player failed game
//    - player won game

@implementation CardTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.players = [NSMutableArray array];
    }
    return self;
}

static UIFont* cardCharacters18 = nil;
static UIFont* cardCharacters15 = nil;

+ (void)initialize {
    if (self == [CardTableView class]) {
        cardCharacters18 = [UIFont fontWithName:FONT_CARD_CHARACTERS size:18.f];
        cardCharacters15 = [UIFont fontWithName:FONT_CARD_CHARACTERS size:11.f];
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [HEX_COLOR(0x008000) set];
    CGContextFillRect(context, rect);

    NSUInteger playersCount = MIN(MAX_PLAYERS, self.players.count);
    NSArray* colors = @[HEX_COLOR(0x44ca37), HEX_COLOR(0x66ca37), HEX_COLOR(0x99ca37), HEX_COLOR(0xffca37)];
    for (int i = 0; i < playersCount; i++) {
        CGContextSaveGState(context);
        [self drawTable:i isActive:YES color:colors[i] context:context];
        CGContextRestoreGState(context);
    }
    
    [[UIColor blackColor] set];
    for (int i = 0; i < playersCount; i++) {
        Player* player = self.players[i];
        if (player.name) {
            NSLog(@"%@", [NSValue valueWithCGRect:CGRectMake(80.f + (i > 1 ? 315.f : .0f), TABLE_TOP_OFFSET + 97.f + (i % 2 == 0 ? .0f : 30.f), 90.f, 20.f)]);
            [player.name drawInRect:CGRectMake(80.f + (i > 1 ? 315.f : .0f), TABLE_TOP_OFFSET + 97.f + (i % 2 == 0 ? .0f : 30.f), 90.f, 20.f) withFont:cardCharacters15 lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        }
    }
    
    if (playersCount < MAX_PLAYERS) {
        for (int i = playersCount; i < MAX_PLAYERS; i++) {
            [self drawTable:i isActive:NO color:colors[i] context:context];
        }
    }
    
}

// MARK: actions

- (void)newPlayer:(Player*)player {
    [self.players addObject:player];
    [self setNeedsDisplay];
}

// MARK: private

- (UILabel *)lblTimer {
    if (!_lblTimer) {
        static CGFloat lblWidth = 100.f;
        _lblTimer = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - lblWidth / 2, 20.f, lblWidth, 20.f)];
        _lblTimer.font = cardCharacters18;
        _lblTimer.textAlignment = NSTextAlignmentCenter;
        _lblTimer.textColor = [UIColor blackColor];
        _lblTimer.backgroundColor = [UIColor clearColor];
    }
    return _lblTimer;
}

// MARK: __draw

- (void)drawTable:(table_pos_t)tablePosition isActive:(BOOL)active color:(UIColor*)color context:(CGContextRef)context {
    static CGFloat width = 200.f;
    static CGFloat offset = 10.f;
    static CGFloat height = 115.f;
    static CGFloat radius = 36.f;
    static CGFloat internalRadius = 50.f;
    
    if (active) {
        [color set];
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    else {
        [[[UIColor blackColor] colorWithAlphaComponent:.15f] set];
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] colorWithAlphaComponent:.15f].CGColor);
    }
    
    CGRect fillRect = CGRectZero;
    CGPoint drawAtPoint = CGPointMake(self.frame.size.width / 2 - (width * 2 + offset) / 2, TABLE_TOP_OFFSET);
    switch (tablePosition) {
        case TOP_LEFT:
            fillRect = CGRectMake(drawAtPoint.x, drawAtPoint.y, width, height);
            break;
        case BOTTOM_LEFT:
            fillRect = CGRectMake(drawAtPoint.x, offset + height + drawAtPoint.y, width, height);
            break;
        case TOP_RIGHT:
            fillRect = CGRectMake(offset + width + drawAtPoint.x, drawAtPoint.y, width, height);
            break;
        case BOTTOM_RIGHT:
            fillRect = CGRectMake(offset + width + drawAtPoint.x, offset + height + drawAtPoint.y, width, height);
            break;
        default:
            break;
    }
    CGFloat minx = CGRectGetMinX(fillRect);
    CGFloat midx = CGRectGetMidX(fillRect);
    CGFloat maxx = CGRectGetMaxX(fillRect);
    CGFloat miny = CGRectGetMinY(fillRect);
    CGFloat midy = CGRectGetMidY(fillRect);
    CGFloat midMidRectY = (midy - miny) / 2.f;
    CGFloat maxy = CGRectGetMaxY(fillRect);
    
    if (tablePosition == TOP_LEFT) {
        CGContextMoveToPoint(context, minx, midy);
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
        CGContextAddLineToPoint(context, maxx, miny);
        CGContextAddLineToPoint(context, maxx, midy - midMidRectY);
        CGContextAddArcToPoint(context, midx, midy - midMidRectY, midx, maxy, internalRadius);
        CGContextAddLineToPoint(context, midx, maxy);
        CGContextAddLineToPoint(context, minx, maxy);
    }
    else if (tablePosition == BOTTOM_LEFT) {
        CGContextMoveToPoint(context, minx, miny);
        CGContextAddLineToPoint(context, midx, miny);
        CGContextAddArcToPoint(context, midx, midy + midMidRectY, maxx, midy + midMidRectY, internalRadius);
        CGContextAddLineToPoint(context, maxx, midy + midMidRectY);
        CGContextAddLineToPoint(context, maxx, maxy);
        CGContextAddLineToPoint(context, midx, maxy);
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, internalRadius);
        CGContextAddLineToPoint(context, minx, miny);
    }
    else if (tablePosition == TOP_RIGHT) {
        CGContextMoveToPoint(context, minx, miny);
        CGContextAddLineToPoint(context, midx, miny);
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
        CGContextAddLineToPoint(context, maxx, maxy);
        CGContextAddLineToPoint(context, midx, maxy);
        CGContextAddArcToPoint(context, midx, midy - midMidRectY, minx, midy - midMidRectY, internalRadius);
        CGContextAddLineToPoint(context, minx, midy - midMidRectY);
    }
    else if (tablePosition == BOTTOM_RIGHT) {
        CGContextMoveToPoint(context, minx, midy + midMidRectY);
        CGContextAddArcToPoint(context, midx, midy + midMidRectY, midx, miny, internalRadius);
        CGContextAddLineToPoint(context, midx, miny);
        CGContextAddLineToPoint(context, maxx, miny);
        CGContextAddLineToPoint(context, maxx, midy);
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
        CGContextAddLineToPoint(context, minx, maxy);
    }
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
