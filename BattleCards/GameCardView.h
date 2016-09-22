//
//  GameCardView.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCard.h"

@class GameCardView;


@protocol GameCardViewDelegate <NSObject>

-(void)gameCardViewTapped:(GameCardView*)sender;

@end


@interface GameCardView : UIView

@property (nonatomic) BOOL active;
@property (nonatomic) id<GameCardViewDelegate> delegate;

-(void) setGameCard:(GameCard*)card;
-(GameCard*) getGameCard;
-(void) showIcon;
-(void) showScore;

@end
