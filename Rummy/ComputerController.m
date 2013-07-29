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
    // put deck
    Action* putDeckAction = [[Action alloc] init];
    putDeckAction.type = PUT_DECK;
    [actions addObject:putDeckAction];
    
    for (Player* player in self.rummy.players) {
        Action* newPlayerAction = [[Action alloc] init];
        newPlayerAction.type = NEW_PLAYER;
        newPlayerAction.data = @{ACTION_OBJECT: player};
        [actions addObject:newPlayerAction];
        
        // receive initial cards
        Action* receiveInitialCardsAction = [[Action alloc] init];
        receiveInitialCardsAction.type = RECEIVE_INITIAL_CARDS;
        receiveInitialCardsAction.data = @{ACTION_OBJECT: player};
        [actions addObject:receiveInitialCardsAction];
    }
    
    self.rummy.actions = actions;
    [self.rummy step];
    
    [self resetRound];
    [self performSelector:@selector(move) withObject:nil afterDelay:2.0];
}

- (void)resetRound {
    self.rummy.isRound2State = NO;
    for (Player* player in self.rummy.players) {
        player.topCardsOnTheTable = 0;
    }
}

- (void)didTapUserOnSelfDeck {
    NSMutableArray* actions = [NSMutableArray array];
    for (Player* player in self.rummy.players) {
        if (player.isLocalPlayer) {
            if (player.topCardsOnTheTable > 0 && !self.rummy.isRound2State) {
                return;
            }
            else if (player.topCardsOnTheTable > 1 && self.rummy.isRound2State) {
                return;
            }
            Action* putCardAction = [[Action alloc] init];
            putCardAction.type = PLAYER_PUT_CARD;
            putCardAction.data = @{ACTION_OBJECT: player, ACTION_OBJECT2:@(1)};
            [actions addObject:putCardAction];
            player.topCardsOnTheTable = 1;
        }
    }
    
    self.rummy.actions = actions;
    [self.rummy step];
    [self performSelector:@selector(round) withObject:nil afterDelay:1.0];
}

- (void)round {
    NSMutableArray* roundCards = [NSMutableArray array];
    NSArray* roundPlayers = self.rummy.isRound2State ? self.rummy.secondRoundPlayers : self.rummy.players;
    for (Player* player in roundPlayers) {
        if (player.topCardsOnTheTable == 0) {
            return;
        }
        else if (player.topCardsOnTheTable == 1 && !self.rummy.isRound2State) {
            [roundCards addObject:player.deck.cards[0]];
        }
        else if (player.topCardsOnTheTable == 2 && self.rummy.isRound2State) {
            [roundCards addObject:player.deck.cards[1]];
        }
    }
    // compare result
    Card* maxCard = nil;
    for (int i = 0; i < roundCards.count; i++) {
        Card* card = roundCards[i];
        if ([Rummy compareCard:card withCard:maxCard] == BIGGER) {
            maxCard = [[Card alloc] init];
            maxCard.suit = card.suit;
            maxCard.number = card.number;
        }
    }
    
    NSMutableArray* maxIds = [NSMutableArray array];
    for (int i = 0; i < roundCards.count; i++) {
        Card* card = roundCards[i];
        if ([Rummy compareCard:card withCard:maxCard] == EQUAL) {
            [maxIds addObject:@(i)];
        }
    }
    
    // check if users failed game
    
    // second round
    if (maxIds.count > 1) {
        self.rummy.isRound2State = YES;
        
        [self move];
        return;
    }
    // remove cards from failed users
    NSMutableArray* cards = [NSMutableArray array];
    for (Player* player in self.rummy.players) {
        [cards addObject:[player.deck pop_top]];
    }
    if (self.rummy.isRound2State) {
        for (Player* player in self.rummy.secondRoundPlayers) {
            [cards addObject:[player.deck pop_top]];
        }
    }
    // add to win user
    Player* winPlayer =  roundPlayers[((NSNumber*)maxIds[0]).intValue];
    for (Card* card in cards) {
        [winPlayer.deck add_card:card];
    }
    
    // action player win round
    Action* playerWonAction = [[Action alloc] init];
    playerWonAction.type = PLAYER_WON_ROUND;
    playerWonAction.data = @{ACTION_OBJECT: winPlayer};
    
    self.rummy.actions = @[playerWonAction];
    [self.rummy step];
    
    // reset round
    [self resetRound];
    [self performSelector:@selector(move) withObject:nil afterDelay:1.0];
}

- (void)move {
    NSMutableArray* actions = [NSMutableArray array];
    for (Player* player in self.rummy.players) {
        if (player.isLocalPlayer) {
            continue;
        }
        Action* putCardAction = [[Action alloc] init];
        putCardAction.type = PLAYER_PUT_CARD;
        putCardAction.data = @{ACTION_OBJECT: player, ACTION_OBJECT2:@(1)};
        [actions addObject:putCardAction];
        player.topCardsOnTheTable = 1;
    }
    
    self.rummy.actions = actions;
    [self.rummy step];
}

@end
