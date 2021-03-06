//
//  BombCard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/10/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "BombCard.h"
#import "GameBoard.h"

@implementation BombCard


- (void) setupProperties {
    _score = 5;
    _priority = 5;
    _name = @"Bomb";
    _effectDescription = @"Destroys all score cards in this and adjacent columns. Always activates when played";
    _iconName = @"Bomb";
    _tintColor = [UIColor colorWithRed:1.0 green:0.64 blue:0.0 alpha:1.0];
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
    return YES;
}

-(BOOL)canRespondToActionInSlot:(int)slot {
    return YES;
}

-(void)activateInSlot:(int)slot {
    GameBoard* board = [GameBoard sharedBoard];
    
    [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot-1];
    [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
    [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot+1];
    
    [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot-1];
    [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot];
    [board setState:GameBoardSlotStateWillBeEmptied forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:slot+1];
}

-(void)respondToActionInSlot:(int)slot {
    // does same thing regardless of board side
    [self activateInSlot:slot];
}

-(void (^)())animationBlockWithCoordinator:(AnimationCoordinator *)coordinator {
    return nil;
}


@end
