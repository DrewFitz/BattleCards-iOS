//
//  AnimationCoordinator.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/13/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "GameBoard.h"

typedef struct SourceInfo_t {
    int slot;
    GameBoardRow row;
    GameBoardPlayer player;
} SourceInfo;

@interface AnimationCoordinator : NSObject

-(SourceInfo)source;
-(CGPoint)centerForSlot:(int)slot forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row;

@end
