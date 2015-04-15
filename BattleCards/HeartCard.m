//
//  HeartCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/6/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "HeartCard.h"
#import "GameBoard.h"

@implementation HeartCard

- (void) setupProperties {
    _score = 10;
    _priority = 1;
    _name = @"Heart";
    _effectDescription = @"Protect your score card in this column from destruction.";
    _iconName = @"Heart";
    _tintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
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
    GameBoardSlotState targetState = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
    if (targetState == GameBoardSlotStateWillBeEmptied) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)canRespondToActionInSlot:(int)slot {
    GameBoardSlotState targetState = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot];
    if (targetState == GameBoardSlotStateWillBeEmptied) {
        return YES;
    } else {
        return NO;
    }
}

-(void)activateInSlot:(int)slot {
    [[GameBoard sharedBoard] setState:GameBoardSlotStateActive forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
    [[GameBoard sharedBoard] setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
}

-(void)respondToActionInSlot:(int)slot {
    [[GameBoard sharedBoard] setState:GameBoardSlotStateActive forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot];
    [[GameBoard sharedBoard] setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:slot];
}


@end
