//
//  StartView.h
//  Rummy
//
//  Created by Ilya Ilin on 7/27/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartViewDelegate;

@interface StartView : UIView

@property (nonatomic, assign) id<StartViewDelegate> delegate;

@end

@protocol StartViewDelegate <NSObject>

- (void)startView:(StartView*)view startGameWithComputer:(NSUInteger)players;
- (void)startViewStartGameWithFriends:(StartView*)view;

@end