//
//  CardTableView.h
//  Rummy
//
//  Created by Ilya Ilin on 7/27/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;
@class Deck;

@interface CardTableView : UIView

// Actions
- (void)putDeck:(Deck*)deck;
- (void)receiveInitialCards:(Player*)player;
- (void)playerPutCard:(Player*)player withLevel:(NSUInteger)level;
- (void)playerWonRound:(Player*)player;
- (void)playerWonGame:(Player*)player;
- (void)playerFailedGame:(Player*)player;
- (void)initPlayers;
- (void)playersDrawGame:(NSArray*)players;
- (void)playersRefresh;

@end
