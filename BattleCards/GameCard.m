//
//  GameCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "GameCard.h"

@implementation GameCard

// this is an "abstract" class
-(BOOL) canActivateInSlot:(int)slot {return NO;}
-(BOOL) canRespondToActionInSlot:(int)slot {return NO;}

-(void) activateInSlot:(int)slot {}
-(void) respondToActionInSlot:(int)slot {}

-(void (^)())animationBlockWithCoordinator:(AnimationCoordinator *)coordinator {return nil;};

@end
