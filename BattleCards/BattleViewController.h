//
//  BattleViewController.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCardView.h"
#import "GameBoard.h"

@protocol BattleViewControllerDelegate <NSObject>

- (void)didCloseBattle;

@end

#import "LocalMatch.h"


@interface BattleViewController : UIViewController <GameBoardDelegate, GameCardViewDelegate>

@property (weak, nonatomic) id<BattleViewControllerDelegate> delegate;
@property (strong, nonatomic) LocalMatch* match;

@property (weak, nonatomic) IBOutlet UIView *turnBlockingView;
@property (weak, nonatomic) IBOutlet UILabel *turnPassMessageLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *infoTapGestureRecognizer;

- (IBAction)downSwipeEvent:(id)sender;
- (IBAction)blockingTapEvent:(id)sender;
- (IBAction)infoTapEvent:(id)sender;

-(void)gameBoard:(GameBoard *)board didActivateCard:(GameCard *)card forPlayer:(GameBoardPlayer)player inSlot:(int)slot;

@end

