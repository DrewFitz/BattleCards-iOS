//
//  GameCard.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCard : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) int priority;
@property (readonly, nonatomic, strong) NSString* name;
@property (readonly, nonatomic, strong) NSString* effectDescription;
@property (readonly, nonatomic, strong) NSString* iconName;

// called when resolving as played action
-(BOOL) canActivateInSlot:(int)slot;
// called when resolving as trap
-(BOOL) canRespondToActionInSlot:(int)slot;

// do the actions for resolving
-(void) activateInSlot:(int)slot;
-(void) respondToActionInSlot:(int)slot;

@end
