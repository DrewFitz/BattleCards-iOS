//
//  LocalMatch.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/4/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocalMatch;

#import "BattleViewController.h"

@interface LocalMatch : NSObject <NSCoding>

@property (nonatomic) NSString* matchID;
@property (nonatomic) NSArray* players;

// load this match's data into the global gameplay objects
-(void)makeActiveMatch;

// the current player has ended their turn
// update the game state
-(void)commitTurn;

@end
