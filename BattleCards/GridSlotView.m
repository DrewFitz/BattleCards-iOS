//
//  DummyView.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "GridSlotView.h"

@implementation GridSlotView

@synthesize targetView = _targetView;

-(instancetype)init {
    self = [super init];
    
    if (self) {
        // don't block touches
        self.exclusiveTouch = NO;
    }
    
    return self;
}

-(void)setTargetView:(UIView *)targetView {
    CGRect frame = self.frame;
    
    _targetView = targetView;
    
    [_targetView setFrame:frame];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [_targetView setFrame:frame];
}

@end
