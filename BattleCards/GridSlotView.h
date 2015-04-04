//
//  DummyView.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridSlotView : UIView

@property (nonatomic) int gridX;
@property (nonatomic) int gridY;

@property (weak, nonatomic) UIView* targetView;

@end
