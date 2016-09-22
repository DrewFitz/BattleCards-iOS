//
//  NullCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/4/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "NullCard.h"

@implementation NullCard

- (void) setupProperties {
    _score = 0;
    _priority = 0;
    _name = @"Null";
    _effectDescription = @"Does nothing. A waste of space.";
    _iconName = @"Null";
    _tintColor = [UIColor colorWithWhite:0.5 alpha:1.0];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupProperties];
    }
    return self;
}

-(BOOL)canActivateInSlot:(int)slot {
    return NO;
}

-(BOOL)canRespondToActionInSlot:(int)slot {
    return NO;
}

-(void)activateInSlot:(int)slot {
}

-(void)respondToActionInSlot:(int)slot {
}



@end
