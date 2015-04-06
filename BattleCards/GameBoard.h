//
//  GameBoard.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCard.h"


typedef enum : NSInteger {
    GameBoardSlotStateError = -1,       // out of bounds slot
    GameBoardSlotStateEmpty = 0,        // no card
    GameBoardSlotStateActive = 1,           // unresolved card
    GameboardSlotStateInactive = 2,         // resolved card (full slot)

    GameBoardSlotStateWillBeEmptied = 3,    // slot will be empty on end of resolution
    GameBoardSlotStateWillBeNull = 4        // slot will be filled with null score card at end of resolution
} GameBoardSlotState;

typedef enum : NSUInteger {
    GameBoardPlayerLocal = 1,
    GameBoardPlayerOpponent = 2
} GameBoardPlayer;

typedef enum : NSUInteger {
    GameBoardRowAction = 1,
    GameBoardRowScore = 2
} GameBoardRow;

typedef enum : NSUInteger {
    GameBoardTurnOrderLocalFirst = 1,
    GameBoardTurnOrderLocalSecond = 2
} GameBoardTurnOrder;


@class GameBoard;

@protocol GameBoardDelegate <NSObject>

@optional
-(void)gameBoardDidChange:(GameBoard*)board;

@end


@interface GameBoard : NSObject

@property (nonatomic) GameBoardTurnOrder turnOrder;
@property (weak, nonatomic) id<GameBoardDelegate> delegate;

+ (instancetype)sharedBoard;

-(GameCard*) getCardForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;
-(void) setCard:(GameCard*)card forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;

-(GameBoardSlotState) getStateForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;
-(void) setState:(GameBoardSlotState)state forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;

-(void)resolveBoard;

-(NSData*)boardData;
-(void)loadData:(NSData*)data;

@end

