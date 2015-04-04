//
//  BattleViewController.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBoard.h"

@interface BattleViewController : UIViewController <GameBoardDelegate, UIGestureRecognizerDelegate>

- (IBAction)downSwipeEvent:(id)sender;
- (IBAction)upSwipeEvent:(id)sender;
- (IBAction)tapEvent:(id)sender;

@end
