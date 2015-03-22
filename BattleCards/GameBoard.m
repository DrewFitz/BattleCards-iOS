//
//  GameBoard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "GameBoard.h"


@implementation GameBoard {
    GameBoardSlotState gameBoardStates[16];
    GameCard* gameBoardCards[16];
}

+ (instancetype)sharedBoard {
    static GameBoard* sharedBoard;
    if (sharedBoard == nil) {
        sharedBoard = [[GameBoard alloc] init];
    }
    return sharedBoard;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i < 16; i++) {
            gameBoardStates[i] = GameBoardSlotStateEmpty;
            gameBoardCards[i] = nil;
        }
    }
    return self;
}

-(int) getOffsetWithPlayer:(GameBoardPlayer)player row:(GameBoardRow)row {
    int playerOffset = 0;
    if (player == GameBoardPlayerLocal && self.turnOrder == GameBoardTurnOrderLocalSecond) {
        playerOffset = 8;
    } else if (player == GameBoardPlayerOpponent && self.turnOrder == GameBoardTurnOrderLocalFirst) {
        playerOffset = 8;
    }
    
    int rowOffset = 0;
    if (row == GameBoardRowScore) {
        rowOffset = 4;
    }
    
    return playerOffset + rowOffset;
}

-(GameCard *)getCardForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    int offset = [self getOffsetWithPlayer:player row:row];
   
    return gameBoardCards[offset + slot];
}

-(void)setCard:(GameCard *)card forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    int offset = [self getOffsetWithPlayer:player row:row];
    
    gameBoardCards[offset + slot] = card;
}

-(GameBoardSlotState)getStateForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    int offset = [self getOffsetWithPlayer:player row:row];
   
    return gameBoardStates[offset + slot];
}

-(void)setState:(GameBoardSlotState)state forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    int offset = [self getOffsetWithPlayer:player row:row];
    
    gameBoardStates[offset + slot] = state;
}

@end
