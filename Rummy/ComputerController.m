//
//  ComputerController.m
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "ComputerController.h"
#import "Rummy.h"
#import "Player.h"
#import "Deck.h"
#import "Action.h"

@interface ComputerController ()

@property (nonatomic, strong) Rummy* rummy;

@end

@implementation ComputerController

// MARK: ControllerProtocol

- (void)loadRummyInstance:(Rummy *)rummy withCardTableView:(CardTableView *)cardTableView {
    self.rummy = rummy;
    rummy.controller = self;
    rummy.cardTableView = cardTableView;
    NSMutableArray* players = [NSMutableArray array];
    
    Player* player1 = [[Player alloc] init];
    player1.name = NSLocalizedString(@"ME", nil);
    player1.playerId = @(1);
    player1.isLocalPlayer = YES;
    [players addObject:player1];
    
    for (int i = 0; i < self.computerPlayers; i++) {
        Player* computer = [[Player alloc] init];
        computer.name = [NSString stringWithFormat:NSLocalizedString(@"Computer #%d", nil), i + 1];
        computer.playerId = @(2 + i);
        [players addObject:computer];
    }
    
    rummy.currentUserId = player1.playerId;
    rummy.players = players;
    
    Deck* mainDeck = [[Deck alloc] initWithJokers:YES full:YES];
    rummy.deck = mainDeck;
}

- (void)start {
    while (self.rummy.deck.cards_left) {
        for (Player* player in self.rummy.players) {
            Card* card = [self.rummy.deck pop_top];
            if (!card) {
                break;
            }
            [player receive_card:card];
        }
    }
    NSMutableArray* actions = [NSMutableArray array];
    for (Player* player in self.rummy.players) {
        Action* newPlayerAction = [[Action alloc] init];
        newPlayerAction.type = NEW_PLAYER;
        newPlayerAction.data = @{ACTION_OBJECT: player};
        [actions addObject:newPlayerAction];
    }
    self.rummy.actions = actions;
    [self.rummy step];
}

@end
