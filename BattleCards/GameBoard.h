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
    GameBoardSlotStateActive,           // unresolved card
    GameboardSlotStateInactive,         // resolved card (full slot)

    GameBoardSlotStateWillBeEmptied,    // slot will be empty on end of resolution
    GameBoardSlotStateWillBeNull        // slot will be filled with null score card at end of resolution
} GameBoardSlotState;

typedef enum : NSUInteger {
    GameBoardPlayerLocal,
    GameBoardPlayerOpponent
} GameBoardPlayer;

typedef enum : NSUInteger {
    GameBoardRowAction,
    GameBoardRowScore
} GameBoardRow;

typedef enum : NSUInteger {
    GameBoardTurnOrderLocalFirst,
    GameBoardTurnOrderLocalSecond
} GameBoardTurnOrder;


@interface GameBoard : NSObject

+ (instancetype)sharedBoard;

@property (nonatomic) GameBoardTurnOrder turnOrder;

-(GameCard*) getCardForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;
-(void) setCard:(GameCard*)card forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;

-(GameBoardSlotState) getStateForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;
-(void) setState:(GameBoardSlotState)state forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot;

@end
