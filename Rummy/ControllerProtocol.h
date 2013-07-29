//
//  ControllerProtocol.h
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Rummy;
@class CardTableView;

@protocol ControllerProtocol <NSObject>
- (void)loadRummyInstance:(Rummy*)rummy withCardTableView:(CardTableView*)cardTableView;
- (void)start;
- (void)didTapUserOnSelfDeck;

@end
