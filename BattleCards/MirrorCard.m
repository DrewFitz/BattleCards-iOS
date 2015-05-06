//
//  MirrorCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/14/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "MirrorCard.h"
#import "GameBoard.h"

@implementation MirrorCard

- (void) setupProperties {
    _score = 5;
    _priority = 3;
    _name = @"Mirror";
    _effectDescription = @"When your cards are destroyed, destroy the opponent's cards in the same columns.";
    _iconName = @"Mirror";
    _tintColor = [UIColor colorWithRed:0.72 green:0.86 blue:1.0 alpha:1.0];
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
    
    for (int i = 0; i < 4; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:i];
        
        if (state == GameBoardSlotStateWillBeEmptied) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)canRespondToActionInSlot:(int)slot {
    GameBoard* board = [GameBoard sharedBoard];
    
    for (int i = 0; i < 4; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:i];
        
        if (state == GameBoardSlotStateWillBeEmptied) {
            return YES;
        }
    }
    return NO;
}

-(void)activateInSlot:(int)slot {
    GameBoard* board = [GameBoard sharedBoard];
    for (int i = 0; i < 4; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:i];
        
        if (state == GameBoardSlotStateWillBeEmptied) {
            [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:i];
        }
    }
}

-(void)respondToActionInSlot:(int)slot {
    GameBoard* board = [GameBoard sharedBoard];
    for (int i = 0; i < 4; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:i];
        
        if (state == GameBoardSlotStateWillBeEmptied) {
            [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:i];
        }
    }
}
@end
