//
//  DummyView.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "GridSlotView.h"

@implementation GridSlotView

-(instancetype)init {
    self = [super init];
    
    if (self) {
        // don't block touches
        self.exclusiveTouch = NO;
    }
    
    return self;
}

@end
