//
//  CardTableView.h
//  Rummy
//
//  Created by Ilya Ilin on 7/27/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface CardTableView : UIView

// Actions
- (void)newPlayer:(Player*)player;

@end
