//
//  IceCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/10/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "IceCard.h"
#import "GameBoard.h"

@implementation IceCard


- (void) setupProperties {
    _score = 25;
    _priority = 4;
    _name = @"Ice";
    _effectDescription = @"Deactivates opponent's action card in this column.";
    _iconName = @"Ice";
    _tintColor = [UIColor colorWithRed:0.32 green:0.86 blue:1.0 alpha:1.0];
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
    GameBoard* board = [GameBoard sharedBoard];
    
    GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:slot];
    
    if (state == GameBoardSlotStateActive) {
        return YES;
    }
    
    return NO;
}

-(BOOL)canRespondToActionInSlot:(int)slot {
    GameBoard* board = [GameBoard sharedBoard];
    
    GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
    
    if (state == GameBoardSlotStateActive) {
        return YES;
    }
    
    return NO;
}

-(void)activateInSlot:(int)slot {
    GameBoard* board = [GameBoard sharedBoard];
    [board setState:GameboardSlotStateInactive forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:slot];
}

-(void)respondToActionInSlot:(int)slot {
    GameBoard* board = [GameBoard sharedBoard];
    [board setState:GameboardSlotStateInactive forPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
}
@end
