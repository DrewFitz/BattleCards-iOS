//
//  NullCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/4/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "NullCard.h"

@implementation NullCard

@synthesize score;
@synthesize priority;
@synthesize name;
@synthesize effectDescription;
@synthesize iconName;


- (void) setupProperties {
    score = 0;
    priority = 0;
    name = @"Null";
    effectDescription = @"Does nothing. A waste of space.";
    iconName = @"Null";
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
