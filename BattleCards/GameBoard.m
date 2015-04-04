//
//  GameBoard.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "GameBoard.h"
#import "NullCard.h"


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

-(BOOL)resolvePlayer{
    BOOL doResolve = NO;
    BOOL dirty = NO;
    do {
        doResolve = NO;
        int slot = 0;
        int maxPriority = 0;
        for (int i = 0; i < 4; i++) {
            GameBoardSlotState state = [self getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:i];
            if (state == GameBoardSlotStateActive) {
                GameCard* card = [self getCardForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:i];
                if ([card canActivateInSlot:i]) {
                    if (card.priority > maxPriority) {
                        doResolve = YES;
                        maxPriority = card.priority;
                        slot = i;
                    }   
                }
            }
        }
        if (doResolve) {
            GameCard* card = [self getCardForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
            [self setState:GameboardSlotStateInactive forPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
            [card activateInSlot:slot];
            dirty = YES;
        }
    } while (doResolve);
    
    return dirty;
}

-(BOOL)resolveEnemy{
    BOOL doResolve = NO;
    BOOL dirty = NO;
    do {
        doResolve = NO;
        int slot = 0;
        int maxPriority = 0;
        for (int i = 0; i < 4; i++) {
            GameBoardSlotState state = [self getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:i];
            if (state == GameBoardSlotStateActive) {
                GameCard* card = [self getCardForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:i];
                if ([card canRespondToActionInSlot:i]) {
                    if (card.priority > maxPriority) {
                        doResolve = YES;
                        maxPriority = card.priority;
                        slot = i;
                    }   
                }
            }
        }
        if (doResolve) {
            GameCard* card = [self getCardForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:slot];
            [self setState:GameboardSlotStateInactive forPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:slot];
            [card respondToActionInSlot:slot];
            dirty = YES;
        }
    } while (doResolve);
    
    return dirty;
}

-(void)resolveBoard {
    // allow cards to update state
    BOOL wasDirty = NO;
    BOOL firstLoop = YES;
    do {
        wasDirty = [self resolvePlayer];
        if (wasDirty || firstLoop) {
            wasDirty = [self resolveEnemy];
        }
        firstLoop = NO;
    } while (wasDirty);
    
    for (int i = 0; i < 16; i++) {
        GameBoardSlotState state = gameBoardStates[i];
        switch (state) {
            case GameBoardSlotStateWillBeEmptied:
                gameBoardStates[i] = GameBoardSlotStateEmpty;
                gameBoardCards[i] = nil;
                break;
                
            case GameBoardSlotStateWillBeNull:
                gameBoardStates[i] = GameboardSlotStateInactive;
                gameBoardCards[i] = [[NullCard alloc] init];
                break;
                
            default:
                break;
        }
    }
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

-(BOOL) isValidSlot:(int)slot {
    return slot >= 0 && slot < 4;
}

-(GameCard *)getCardForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    if (![self isValidSlot:slot]) {
        return nil;
    }
    int offset = [self getOffsetWithPlayer:player row:row];
   
    return gameBoardCards[offset + slot];
}

-(void)setCard:(GameCard *)card forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    if (![self isValidSlot:slot]) {
        return;
    }
    
    int offset = [self getOffsetWithPlayer:player row:row];
    
    gameBoardCards[offset + slot] = card;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(gameBoardDidChange:)]) {
        [self.delegate gameBoardDidChange:self];
    }
}

-(GameBoardSlotState)getStateForPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    if (![self isValidSlot:slot]) {
        return GameBoardSlotStateError;
    }
    int offset = [self getOffsetWithPlayer:player row:row];
   
    return gameBoardStates[offset + slot];
}

-(void)setState:(GameBoardSlotState)state forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row slot:(int)slot {
    if (![self isValidSlot:slot]) {
        return;
    }
    int offset = [self getOffsetWithPlayer:player row:row];
    
    gameBoardStates[offset + slot] = state;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(gameBoardDidChange:)]) {
        [self.delegate gameBoardDidChange:self];
    }
}

@end
