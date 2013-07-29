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
    int i = 3;
    while (self.rummy.deck.cards_left) {
        for (Player* player in self.rummy.players) {
            Card* card = [self.rummy.deck pop_top];
            if (!card) {
                break;
            }
            if (player.isLocalPlayer) { if (i-- > 0) {
                [player receive_card:card];     }
            } else
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
        newPlayerAction.type = INIT_PLAYERS;
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
    
    [self performSelector:@selector(move) withObject:nil afterDelay:2.0];
}

- (void)resetRound {
    self.rummy.isRound2State = NO;
    self.rummy.secondRoundPlayers = nil;
    for (Player* player in self.rummy.players) {
        player.topCardsOnTheTable = 0;
    }
    
    Action* playersRefreshAction = [[Action alloc] init];
    playersRefreshAction.type = PLAYERS_REFRESH;
    self.rummy.actions = @[playersRefreshAction];
    [self.rummy step];
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
            putCardAction.data = @{ACTION_OBJECT: player, ACTION_OBJECT2:@(self.rummy.isRound2State ? 2 : 1)};
            [actions addObject:putCardAction];
            player.topCardsOnTheTable = self.rummy.isRound2State ? 2 : 1;
        }
    }
    
    self.rummy.actions = actions;
    [self.rummy step];
    [self performSelector:@selector(round) withObject:nil afterDelay:1.5];
}

- (void)round {
    NSMutableArray* actions = [NSMutableArray array];
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
    
    NSMutableArray* playersWithMaxCard = [NSMutableArray array];
    for (int i = 0; i < roundCards.count; i++) {
        Card* card = roundCards[i];
        if ([Rummy compareCard:card withCard:maxCard] == EQUAL) {
            [playersWithMaxCard addObject:roundPlayers[i]];
        }
    }
    
    // check if players failed game
    for (Player* player in roundPlayers) {
        BOOL isPlayerWithMaxCard = NO;
        for (Player* playerWithMaxCard in playersWithMaxCard) {
            if (playerWithMaxCard.playerId.intValue == player.playerId.intValue) {
                isPlayerWithMaxCard = YES;
                break;
            }
        }
        if (!isPlayerWithMaxCard && player.deck.cards.count < 2) {
            [actions addObject:[self removePlayer:player]];
        }
        else if (!isPlayerWithMaxCard && self.rummy.isRound2State && player.deck.cards.count < 3) {
            [actions addObject:[self removePlayer:player]];
        }
    }
    if (self.rummy.players.count == 1) {
        Action* playerWonAction = [[Action alloc] init];
        playerWonAction.type = PLAYER_WON_ROUND;
        playerWonAction.data = @{ACTION_OBJECT: self.rummy.players[0]};
        [actions addObject:playerWonAction];
        
        self.rummy.actions = actions;
        [self.rummy step];
        return;
    }
    
    // second round
    if (playersWithMaxCard.count > 1) {
        // Draw
        if (self.rummy.isRound2State) {
            Action* playersDrawAction = [[Action alloc] init];
            playersDrawAction.type = PLAYERS_DRAW_GAME;
            playersDrawAction.data = @{ACTION_OBJECT: playersWithMaxCard};
            [actions addObject:playersDrawAction];
            self.rummy.actions = actions;
            [self.rummy step];
            
            return;
        }
        self.rummy.isRound2State = YES;
        self.rummy.secondRoundPlayers = playersWithMaxCard;
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
    Player* winPlayer = playersWithMaxCard[0];
    for (Card* card in cards) {
        [winPlayer.deck add_card:card];
    }
    
    // action player win round
    Action* playerWonAction = [[Action alloc] init];
    playerWonAction.type = PLAYER_WON_ROUND;
    playerWonAction.data = @{ACTION_OBJECT: winPlayer};
    [actions addObject:playerWonAction];
    
    self.rummy.actions = actions;
    [self.rummy step];
    
    // reset round
    [self resetRound];
    [self performSelector:@selector(move) withObject:nil afterDelay:1.0];
}

- (Action*)removePlayer:(Player*)player {
    NSMutableArray* players = [NSMutableArray array];
    for (Player* rummyPlayer in self.rummy.players) {
        if (player != rummyPlayer) {
            [players addObject:rummyPlayer];
        }
    }
    self.rummy.players = players;
    
    NSMutableArray* secondRoundPlayers = [NSMutableArray array];
    for (Player* rummyPlayer in self.rummy.secondRoundPlayers) {
        if (player != rummyPlayer) {
            [secondRoundPlayers addObject:rummyPlayer];
        }
    }
    self.rummy.secondRoundPlayers = secondRoundPlayers;
    
    Action* playerFailedAction = [[Action alloc] init];
    playerFailedAction.type = PLAYER_FAILED_GAME;
    playerFailedAction.data = @{ACTION_OBJECT: player};
    return playerFailedAction;
}

- (void)move {
    BOOL localPlayerInGame = NO;
    
    NSMutableArray* actions = [NSMutableArray array];
    NSArray* roundPlayers = self.rummy.isRound2State ? self.rummy.secondRoundPlayers : self.rummy.players;
    for (Player* player in roundPlayers) {
        if (player.isLocalPlayer) {
            localPlayerInGame = YES;
            continue;
        }
        Action* putCardAction = [[Action alloc] init];
        putCardAction.type = PLAYER_PUT_CARD;
        putCardAction.data = @{ACTION_OBJECT: player, ACTION_OBJECT2:@(self.rummy.isRound2State ? 2 : 1)};
        [actions addObject:putCardAction];
        player.topCardsOnTheTable = self.rummy.isRound2State ? 2 : 1;
    }
    
    self.rummy.actions = actions;
    [self.rummy step];
    
    if (!localPlayerInGame) {
        [self performSelector:@selector(round) withObject:nil afterDelay:1.0];
    }
}

@end
