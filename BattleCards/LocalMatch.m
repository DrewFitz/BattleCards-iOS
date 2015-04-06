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
    NSData* boardData;
}

-(void)makeActiveMatch {
    GameBoard* board = [GameBoard sharedBoard];
    
    if (boardData) {
        [board loadData:boardData];
    }
}

-(void)commitTurn {
    GameBoard* board = [GameBoard sharedBoard];
    
    [board resolveBoard];
    
    boardData = [board boardData];
    
    GameBoardTurnOrder order = board.turnOrder;
    
    // swap to other player's turn
    if (order == GameBoardTurnOrderLocalFirst) {
        board.turnOrder = GameBoardTurnOrderLocalSecond;
    } else {
        board.turnOrder = GameBoardTurnOrderLocalFirst;
    }
}

#pragma mark - NSCoding protocol

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.matchID = [aDecoder decodeObjectForKey:@"matchID"];
        boardData = [aDecoder decodeObjectForKey:@"boardData"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.matchID forKey:@"matchID"];
    [aCoder encodeObject:boardData forKey:@"boardData"];
}

@end
