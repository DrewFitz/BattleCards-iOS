//
//  LightningCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "LightningCard.h"
#import "GameBoard.h"

@implementation LightningCard

@synthesize score;
@synthesize priority;
@synthesize name;
@synthesize effectDescription;
@synthesize iconName;

- (void) setupProperties {
    score = 5;
    priority = 1;
    name = @"Lightning";
    effectDescription = @"Destroy the opponent's score card in this column.";
    iconName = @"LightningBolt";
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
    GameBoardSlotState targetState = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot];
    if (targetState != GameBoardSlotStateEmpty) {
        return YES;
    } else {
        return NO;
    }
}

-(void)activateInSlot:(int)slot {
    [[GameBoard sharedBoard] setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot];
}

@end
