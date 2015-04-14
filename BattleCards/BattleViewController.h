//
//  BattleViewController.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameBoard.h"

@protocol BattleViewControllerDelegate <NSObject>

- (void)didCloseBattle;

@end

#import "LocalMatch.h"


@interface BattleViewController : UIViewController <GameBoardDelegate>

@property (weak, nonatomic) id<BattleViewControllerDelegate> delegate;
@property (strong, nonatomic) LocalMatch* match;

@property (weak, nonatomic) IBOutlet UIView *turnBlockingView;

- (IBAction)downSwipeEvent:(id)sender;
- (IBAction)tapEvent:(id)sender;

-(void)gameBoard:(GameBoard *)board didActivateCard:(GameCard *)card forPlayer:(GameBoardPlayer)player inSlot:(int)slot;

@end

