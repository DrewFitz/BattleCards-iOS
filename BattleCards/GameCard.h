//
//  GameCard.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnimationCoordinator.h"

@interface GameCard : NSObject {
    @protected
    int _score;
    int _priority;
    NSString* _name;
    NSString* _effectDescription;
    NSString* _iconName;
    UIColor* _tintColor;
}

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) int priority;
@property (readonly, nonatomic, strong) NSString* name;
@property (readonly, nonatomic, strong) NSString* effectDescription;
@property (readonly, nonatomic, strong) NSString* iconName;
@property (readonly, nonatomic, strong) UIColor* tintColor;

// called when resolving as played action
-(BOOL) canActivateInSlot:(int)slot;
// called when resolving as trap
-(BOOL) canRespondToActionInSlot:(int)slot;

// do the actions for resolving
-(void) activateInSlot:(int)slot;
-(void) respondToActionInSlot:(int)slot;

-(void(^)())animationBlockWithCoordinator:(AnimationCoordinator*)coordinator;

@end
