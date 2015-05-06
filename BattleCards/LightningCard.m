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

- (void) setupProperties {
    _score = 25;
    _priority = 2;
    _name = @"Lightning";
    _effectDescription = @"Destroy the opponent's score card in this column.";
    _iconName = @"LightningBolt";
    _tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
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

-(BOOL)canRespondToActionInSlot:(int)slot {
    GameBoardSlotState targetState = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
    if (targetState != GameBoardSlotStateEmpty) {
        return YES;
    } else {
        return NO;
    }
}

-(void)activateInSlot:(int)slot {
    [[GameBoard sharedBoard] setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot];
}

-(void)respondToActionInSlot:(int)slot {
    [[GameBoard sharedBoard] setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
}

@end
