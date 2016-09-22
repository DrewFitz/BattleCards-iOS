//
//  LocalMatch.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/4/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "LocalMatch.h"
#import "GameBoard.h"

@implementation LocalMatch {
    GameBoardTurnOrder currentTurnOrder;
    NSData* boardData;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        currentTurnOrder = GameBoardTurnOrderLocalFirst;
        _completed = NO;
    }
    return self;
}

-(void)makeActiveMatch {
    GameBoard* board = [GameBoard sharedBoard];
    
    if (boardData) {
        [board loadData:boardData];
    } else {
        [board clearBoard];
    }
    
    board.turnOrder = currentTurnOrder;
}

-(void)commitTurn {
    GameBoard* board = [GameBoard sharedBoard];
    
    [board resolveBoard];
    
    boardData = [board boardData];
    
    // swap to other player's turn
    if (board.turnOrder == GameBoardTurnOrderLocalFirst) {
        board.turnOrder = GameBoardTurnOrderLocalSecond;
    } else {
        board.turnOrder = GameBoardTurnOrderLocalFirst;
    }
    
    currentTurnOrder = board.turnOrder;
}

#pragma mark - NSCoding protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.matchID = [aDecoder decodeObjectForKey:@"matchID"];
        boardData = [aDecoder decodeObjectForKey:@"boardData"];
        currentTurnOrder = [aDecoder decodeIntegerForKey:@"currentTurnOrder"];
        _completed = [aDecoder decodeBoolForKey:@"completed"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.matchID forKey:@"matchID"];
    [aCoder encodeObject:boardData forKey:@"boardData"];
    [aCoder encodeInteger:currentTurnOrder forKey:@"currentTurnOrder"];
    [aCoder encodeBool:_completed forKey:@"completed"];
}

@end
