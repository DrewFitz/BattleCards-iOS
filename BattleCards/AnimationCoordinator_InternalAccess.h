//
//  AnimationCoordinator_InternalAccess.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/13/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "AnimationCoordinator.h"

@interface AnimationCoordinator ()

-(void)setSource:(SourceInfo)source;
-(void)setCenter:(CGPoint)center forSlotNumber:(int)slotNumber;

@end
