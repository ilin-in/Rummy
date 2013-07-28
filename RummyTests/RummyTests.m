//
//  RummyTests.m
//  RummyTests
//
//  Created by Ilya Ilin on 7/26/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import "RummyTests.h"
#import "Player.h"
#import "Deck.h"

@implementation RummyTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// MARK: Play with computer

- (void)testPlayWithComputer
{
    int cards_each = 28;
    
    Player* player1 = [[Player alloc] init];
    player1.name = @"Tim";
    
    Player* computer = [[Player alloc] init];
    player1.name = @"Computer";
    
    Deck* mainDeck = [[Deck alloc] initWithJokers:YES full:YES];
    
    while(cards_each > 0)
    {
        Card* card = [mainDeck pop_top];
        if (!card) {
            break;
        }
        [player1 receive_card:card];
        
        card = [mainDeck pop_top];
        if (!card) {
            break;
        }
        [computer receive_card:card];
        
        cards_each--;
    }
    
    // Remote -> action -> step
    // Computer -> action - > step
    // User -> action -> step
    
    // Actions
//    - recieve player card
//    - new player with name
//    - player put card
//    - player win round
//    - round 2 between players
//    - player recive initial cards
//    - player failed game
//    - player win game
    
    
    NSLog(@"Tim's Cards: ");
    [player1 dump_cards];
    NSLog(@"computer's Cards: ");
    [computer dump_cards];
    NSLog(@"remaining deck: ");
    [mainDeck dump_deck];
}

@end
