//
//  AnimationCoordinator.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/13/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "AnimationCoordinator.h"
#import "AnimationCoordinator_InternalAccess.h"

@implementation AnimationCoordinator {
    CGPoint _slotCenters[16];
    SourceInfo _source;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        memset(_slotCenters, 0, sizeof(_slotCenters));
    }
    return self;
}

-(SourceInfo)source {
    return _source;
}

-(void)setSource:(SourceInfo)source {
    _source = source;
}

-(CGPoint)centerForSlot:(int)slot forPlayer:(GameBoardPlayer)player inRow:(GameBoardRow)row {
    if (player == GameBoardPlayerOpponent) {
        int offset = 0;
        if (row == GameBoardRowAction) {
            offset += 4;
        }
        return _slotCenters[offset + slot];
        
    } else if (player == GameBoardPlayerLocal) {
        int offset = 8;
        if (row == GameBoardRowScore) {
            offset += 4;
        }
        return _slotCenters[offset + slot];
    }
    return CGPointZero;
}

#pragma mark - Internal Access Extension

-(void)setCenter:(CGPoint)center forSlotNumber:(int)slotNumber {
    _slotCenters[slotNumber] = center;
}

@end
