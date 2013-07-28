//
//  StartView.m
//  Rummy
//
//  Created by Ilya Ilin on 7/27/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "StartView.h"
#import "CardView.h"

#define kBtnOffset  60.f
#define kBtnSize    (CGSize){220.f, 40.f}
#define kBtnsPoint  (CGPoint){self.frame.size.width / 2 - kBtnSize.width / 2, 100.f}

@interface StartView ()

@property (nonatomic, strong) UIButton* btnPlayWithComputer;
@property (nonatomic, strong) UIButton* btnPlayWithFriends;
@property (nonatomic, strong) UIButton* btnPlayOnline;

@end

@implementation StartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        [self loadView];
    }
    return self;
}

- (void)loadView {
    [self addSubview:self.btnPlayWithComputer];
    [self addSubview:self.btnPlayWithFriends];
    [self addSubview:self.btnPlayOnline];
}

static UIFont* cardCharacters15 = nil;

+ (void)initialize {
    if (self == [StartView class]) {
        cardCharacters15 = [UIFont fontWithName:FONT_CARD_CHARACTERS size:15.f];
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGContextSetShadowWithColor(context, CGSizeMake(1.0f, 2.0f), 3.f, [UIColor blackColor].CGColor);
    [NSLocalizedString(@"Pyanica (Rummy)", nil) drawInRect:CGRectMake(kBtnsPoint.x, 15.f, kBtnSize.width, 20.f) withFont:cardCharacters15 lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
}

// MARK: private

- (UIButton *)btnPlayWithComputer {
    if (!_btnPlayWithComputer) {
        _btnPlayWithComputer = [[UIButton alloc] initWithFrame:(CGRect){{kBtnsPoint.x, kBtnsPoint.y + kBtnOffset}, kBtnSize}];
        [_btnPlayWithComputer setTitle:NSLocalizedString(@"Start with Computer", nil) forState:UIControlStateNormal];
        [_btnPlayWithComputer setBackgroundColor:HEX_COLOR(0x5c82c6)];
        _btnPlayWithComputer.titleLabel.font = cardCharacters15;
        [_btnPlayWithComputer addTarget:self action:@selector(startWithComputer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlayWithComputer;
}

- (UIButton *)btnPlayWithFriends {
    if (!_btnPlayWithFriends) {
        _btnPlayWithFriends = [[UIButton alloc] initWithFrame:(CGRect){{kBtnsPoint.x, kBtnsPoint.y}, kBtnSize}];
        [_btnPlayWithFriends setTitle:NSLocalizedString(@"Start with Friends", nil) forState:UIControlStateNormal];
        [_btnPlayWithFriends setBackgroundColor:HEX_COLOR(0x5c82c6)];
        _btnPlayWithFriends.titleLabel.font = cardCharacters15;
    }
    return _btnPlayWithFriends;
}

- (UIButton *)btnPlayOnline {
    if (!_btnPlayOnline) {
        _btnPlayOnline = [[UIButton alloc] initWithFrame:(CGRect){{kBtnsPoint.x, kBtnsPoint.y + kBtnOffset * 2}, kBtnSize}];
        [_btnPlayOnline setTitle:NSLocalizedString(@"Play online", nil) forState:UIControlStateNormal];
        [_btnPlayOnline setBackgroundColor:HEX_COLOR(0x5c82c6)];
        _btnPlayOnline.titleLabel.font = cardCharacters15;
    }
    return _btnPlayOnline;
}

// MARK: delegate

- (void)startWithComputer {
    if ([self.delegate respondsToSelector:@selector(startView:startGameWithComputer:)]) {
        [self.delegate startView:self startGameWithComputer:3];
    }
}

@end
