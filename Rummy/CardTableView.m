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
#import "Deck.h"

#define MAX_PLAYERS         4
#define TABLE_TOP_OFFSET    50

#define kDeckBacksTag       1

#define kCardBacksTag   100
#define kCardOnDeckTag  150
#define kCardOnDeckSecondRoundTag  200

typedef enum {
    TOP_LEFT, BOTTOM_LEFT, TOP_RIGHT, BOTTOM_RIGHT
} table_pos_t;

@interface CardTableView ()

@property (nonatomic, strong) UILabel* lblTimer;

@end

// Actions
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

    NSUInteger playersCount = MIN(MAX_PLAYERS, [Rummy sharedInstance].players.count);
    NSArray* colors = @[HEX_COLOR(0x44ca37), HEX_COLOR(0x66ca37), HEX_COLOR(0x88ca37), HEX_COLOR(0xaaca37)];
    for (int i = 0; i < playersCount; i++) {
        CGContextSaveGState(context);
        [self drawTable:i isActive:YES color:colors[i] context:context];
        CGContextRestoreGState(context);
    }
    
    [[UIColor blackColor] set];
    for (int i = 0; i < playersCount; i++) {
        Player* player = [Rummy sharedInstance].players[i];
        if (player.name) {
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

- (void)putDeck:(Deck*)deck {
    CardView* card = [[CardView alloc] initWithFrame:(CGRect){{self.frame.size.width / 2 - CARD_SIZE.width / 2, self.frame.size.height / 2 - CARD_SIZE.height / 2}, CARD_SIZE}];
    card.tag = kDeckBacksTag;
    [self addSubview:card];
}

- (void)receiveInitialCards:(Player*)player {
    table_pos_t tablePos = [self tablePosForPlayer:player];
    double speed = 7.5;
    int animCards = 6;
    NSMutableArray* cards = [NSMutableArray array];
    
    double delayInSeconds = (double)tablePos/8.;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (int i = 0; i < animCards; i++) {
            CardView* card = [[CardView alloc] initWithFrame:(CGRect){{self.frame.size.width / 2 - CARD_SIZE.width / 2, self.frame.size.height / 2 - CARD_SIZE.height / 2}, CARD_SIZE}];
            if (i == animCards - 1) {
                if (player.isLocalPlayer) {
                    card.card = player.deck.cards[0];
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserOnSelfCard:)];
                    card.userInteractionEnabled = YES;
                    [card addGestureRecognizer:tap];
                }
                card.tag = kCardBacksTag + tablePos;
            }
            else {
                [cards addObject:card];
            }
            [self addSubview:card];
            
            double delayInSeconds = (double)i/speed;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:.5 animations:^{
                    card.frame = (CGRect){{90.f + (tablePos > 1 ? 305.f : .0f), TABLE_TOP_OFFSET + (tablePos % 2 == 0 ? .0f : 145.f)}, CARD_SIZE};
                }];
            });
        }
    });
    
    delayInSeconds += animCards/speed + .4;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (CardView* cardView in cards) {
            [cardView removeFromSuperview];
        }
    });
    
    CardView* deckBack = (CardView*)[self viewWithTag:kDeckBacksTag];
    if (deckBack) {
        delayInSeconds = (double)3/8.;
        delayInSeconds += animCards/speed - .3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:1.5 animations:^{
                deckBack.frame = (CGRect){{90.f + 305.f, TABLE_TOP_OFFSET + 145.f}, CARD_SIZE};
            } completion:^(BOOL finished) {
                [deckBack removeFromSuperview];
            }];
        });
    }
}

- (void)playerPutCard:(Player*)player withLevel:(NSUInteger)level {
    table_pos_t tablePos = [self tablePosForPlayerId:player.playerId.integerValue];
    double delayInSeconds = (double)tablePos/8.;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CardView* card = (CardView*)[self viewWithTag:kCardBacksTag + tablePos];
        [UIView animateWithDuration:.3 animations:^{
            if (player.deck.cards.count > level) {
                CardView* card2 = [[CardView alloc] initWithFrame:card.frame];
                if (player.isLocalPlayer) {
                    if (player.deck.cards.count > level) {
                        card2.card = player.deck.cards[level];
                    }
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserOnSelfCard:)];
                    card2.userInteractionEnabled = YES;
                    [card2 addGestureRecognizer:tap];
                }
                card2.tag = card.tag;
                [self addSubview:card2];
            }
            card.userInteractionEnabled = NO;
            card.tag = (level == 1 ? kCardOnDeckTag : kCardOnDeckSecondRoundTag) + tablePos;
            card.frame = (CGRect){{200.f + (tablePos > 1 ? 95.f : .0f), 20.f + TABLE_TOP_OFFSET + (tablePos % 2 == 0 ? .0f : 105.f)}, CARD_SIZE};
            if (player.deck.cards.count > (level - 1)) {
                card.card = player.deck.cards[level - 1];
            }
        }];
        
    });
}

- (void)playerWonRound:(Player*)player {
    NSMutableArray* cards = [NSMutableArray array];
    table_pos_t tablePos = [self tablePosForPlayerId:player.playerId.integerValue];
    for (int i = 0; i < [[Rummy sharedInstance] players].count; i++) {
        CardView* cardView = (CardView*)[self viewWithTag:kCardOnDeckTag + i];
        if (cardView) {
            [UIView animateWithDuration:.5 animations:^{
                cardView.frame = (CGRect){{90.f + (tablePos > 1 ? 305.f : .0f), TABLE_TOP_OFFSET + (tablePos % 2 == 0 ? .0f : 145.f)}, CARD_SIZE};
            }];
            [cards addObject:cardView];
        }
    }
    
    double delayInSeconds = .6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (CardView* cardView in cards) {
            [cardView removeFromSuperview];
        }
    });
}

- (void)playerWonGame:(Player*)player {
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ won the game!", nil), player.name] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)playerFailedGame:(Player*)player {
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@ failed the game!", nil), player.name] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

// MARK:

- (void)didTapUserOnSelfCard:(UIGestureRecognizer*)recognizer {
    [[Rummy sharedInstance].controller didTapUserOnSelfDeck];
}

// MARK: private

- (table_pos_t)tablePosForPlayerId:(NSUInteger)playerId {
    for (int i = 0; i < [Rummy sharedInstance].players.count; i++) {
        Player* player = [Rummy sharedInstance].players[i];
        if (player.playerId.integerValue == playerId) {
            return i;
        }
    }
    return 0;
}

- (table_pos_t)tablePosForPlayer:(Player*)player {
    for (int i = 0; i < [Rummy sharedInstance].players.count; i++) {
        Player* _player = [Rummy sharedInstance].players[i];
        if (player.playerId == _player.playerId) {
            return i;
        }
    }
    return 0;
}

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
