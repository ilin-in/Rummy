//
//  ComputerController.h
//  Rummy
//
//  Created by Ilya Ilin on 7/28/13.
//  Copyright (c) 2013 Ilya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControllerProtocol.h"

@interface ComputerController : NSObject <ControllerProtocol>

@property (nonatomic, assign) NSUInteger computerPlayers;

@end
