//
//  ViewController.m
//  Rummy
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "ViewController.h"
#import "CardTableView.h"
#import "StartView.h"
#import "Rummy.h"
#import "ControllerProtocol.h"
#import "ComputerController.h"
#import "BluetoothController.h"
#import "OnlineController.h"

#define kStartViewTag       1
#define kCardTableViewTag   2

@interface ViewController () <StartViewDelegate>

@property (nonatomic, strong) id<ControllerProtocol> controller;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGSize appSize = [[UIScreen mainScreen] bounds].size;
    CardTableView* cardTable = [[CardTableView alloc] initWithFrame:(CGRect){{.0f, .0f}, {appSize.height, appSize.width}}];
    cardTable.tag = kCardTableViewTag;
    [self.view addSubview:cardTable];
    
    StartView* startView = [[StartView alloc] initWithFrame:cardTable.frame];
    startView.tag = kStartViewTag;
    startView.delegate = self;
    [self.view addSubview:startView];
    
//    for (int i = 0; i < 15; i++) {
//        CardView* cardView = [[CardView alloc] initWithFrame:(CGRect){{ (i % 5) * 95.f + 25.f, (i / 5) * 100.f}, CARD_SIZE}];
//        if (i < 14) {
//            Card* card = [[Card alloc] init];
//            card.suit = CLUBS;
//            card.number = (number_t)i;
//            cardView.card = card;
//        }
//        [self.view addSubview:cardView];
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: StartViewDelegate

- (void)startView:(StartView *)view startGameWithComputer:(NSUInteger)players {
    [self hideStartView];
    ComputerController* controller = [[ComputerController alloc] init];
    controller.computerPlayers = players;
    CardTableView* cardTableView = (CardTableView*)[self.view viewWithTag:kCardTableViewTag];
    [controller loadRummyInstance:[Rummy sharedInstance] withCardTableView:cardTableView];
    self.controller = controller;
    
    [self.controller start];
}

- (void)startViewStartGameWithFriends:(StartView *)view {
    [self hideStartView];
    BluetoothController* controller = [[BluetoothController alloc] init];
    CardTableView* cardTableView = (CardTableView*)[self.view viewWithTag:kCardTableViewTag];
    [controller loadRummyInstance:[Rummy sharedInstance] withCardTableView:cardTableView];
    self.controller = controller;
    
    [self.controller start];
}

// MARK: private

- (void)hideStartView {
    __block UIView* startView = [self.view viewWithTag:kStartViewTag];
    if (!startView) {
        return;
    }
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        startView.frame = CGRectOffset(startView.frame, startView.frame.size.width, startView.frame.size.height);
    } completion:^(BOOL finished) {
        [startView removeFromSuperview];
        startView = nil;
    }];
}

@end
