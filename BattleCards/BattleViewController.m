//
//  BattleViewController.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "BattleViewController.h"
#import "GridSlotView.h"
#import "GameCardView.h"
#import "LightningCard.h"
#import "GameBoard.h"

    

@interface BattleViewController ()

@end

@implementation BattleViewController {
    NSMutableArray* gridSlotViews;
    NSMutableArray* gridCardViews;
    NSMutableArray* handCardViews;
    
    GameCardView* currentDraggingView;
    GridSlotView* closestSlot;
    UITouch* draggingTouch;
    CGPoint oldCenter;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingTouch != nil) {
        return;
    }
    
    draggingTouch = [touches anyObject];
    if (draggingTouch) {
        // find closest hand card if any
        CGPoint touchLocation = [draggingTouch locationInView:self.view];
        float minDistance = powf(95.0, 2);
        GameCardView* closestView = nil;
        for (GameCardView* view in handCardViews) {
            float distance = powf( touchLocation.x - view.center.x , 2) + powf(touchLocation.y - view.center.y, 2);
            if (distance < minDistance) {
                minDistance = distance;
                closestView = view;
            }
        }
        if (closestView == nil) {
            draggingTouch = nil;
        } else {
            currentDraggingView = closestView;
            oldCenter = closestView.center;
        }
    }
}

- (IBAction)panGestureAction:(UIPanGestureRecognizer*)sender {
    CGPoint touchLocation = [sender locationInView:self.view];
    
    GridSlotView* closestView = nil;
    float minDistance = powf(95.0, 2);
    
    UIColor* inactiveBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    UIColor* activeBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    for (GridSlotView* view in gridSlotViews) {
        float distance = powf(touchLocation.x - view.center.x, 2) + powf(touchLocation.y - view.center.y, 2);
        if (distance < minDistance) {
            minDistance = distance;
            closestView = view;
        }
        [view setBackgroundColor:inactiveBackgroundColor];
    }
    
    [closestView setBackgroundColor:activeBackgroundColor];
    closestSlot = closestView;
    
    currentDraggingView.center = touchLocation;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:draggingTouch]) {
        // handle drop
        CGPoint newCenter = oldCenter;
        if (closestSlot) {
            int slot = closestSlot.gridX;
            int row = closestSlot.gridY;
            
            if (row == 2) { // player action row
                GameBoardSlotState state = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
//                GameBoardSlotState state = [[GameBoard sharedBoard] getPlayerActionSlot:slot];
                if (state == GameBoardSlotStateEmpty) {
                    [[GameBoard sharedBoard] setState:GameBoardSlotStateNew forPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
//                    [[GameBoard sharedBoard] setPlayerActionSlot:slot toState:GameBoardSlotStateNew];
                    [[GameBoard sharedBoard] setCard:[currentDraggingView getGameCard] forPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
//                    [[GameBoard sharedBoard] setCard:[currentDraggingView getGameCard] forPlayerActionSlot:slot];
                    newCenter = closestSlot.center;
                }
            } else if (row == 3) { // player score row
                GameBoardSlotState state = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
//                GameBoardSlotState state = [[GameBoard sharedBoard] getPlayerScoreSlot:slot];
                if (state == GameBoardSlotStateEmpty) {
                    [[GameBoard sharedBoard] setState:GameBoardSlotStateNew forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
//                    [[GameBoard sharedBoard] setPlayerScoreSlot:slot toState:GameBoardSlotStateNew];
                    [[GameBoard sharedBoard] setCard:[currentDraggingView getGameCard] forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
//                    [[GameBoard sharedBoard] setCard:[currentDraggingView getGameCard] forPlayerScoreSlot:slot];
                    newCenter = closestSlot.center;
                }
            }
        }
        [UIView animateWithDuration:0.5 animations:^{
            currentDraggingView.center = newCenter;
        }];
        draggingTouch = nil;
        currentDraggingView = nil;
        oldCenter = CGPointZero;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    gridSlotViews = [[NSMutableArray alloc] init];
    gridCardViews = [[NSMutableArray alloc] init];
    handCardViews = [[NSMutableArray alloc] init];
    
    
    int gutter = 10;

    int width  = 60;
    int height = 97;

    int verticalSpacer = 12;
    int topGutter  = 20;
    
    int boardWidth  = width*4  + gutter*3;
//    int boardHeight = height*4 + gutter*3 + (verticalSpacer + gutter);
    
    int handWidth   = width*5 + gutter*4;
    
    int viewWidth   = self.view.bounds.size.width;
    int viewHeight = self.view.bounds.size.height;
    
    int sideGutter = (viewWidth - boardWidth) / 2;
    
    int handSideGutter = (viewWidth - handWidth) / 2;
    
    UIColor* slotBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    // layout grid slot views
    for (int i = 0; i < 16; i++) {
        int xIndex = i%4;
        int yIndex = i/4;
        
        int x = sideGutter + xIndex * width + xIndex * gutter;
        int y = topGutter + yIndex * height + yIndex * gutter;
        if (yIndex >= 2) y += verticalSpacer + gutter;
        
        GridSlotView* newGridSlot = [[GridSlotView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [newGridSlot setBackgroundColor:slotBackgroundColor];
        newGridSlot.gridX = xIndex;
        newGridSlot.gridY = yIndex;
        [self.view addSubview:newGridSlot];
        
        [gridSlotViews addObject:newGridSlot];
    }
    
    // insert divider line
    int y = topGutter + 2 * height + 2 * gutter;
    GridSlotView* spacerView = [[GridSlotView alloc] initWithFrame:CGRectMake(0, y, viewWidth, verticalSpacer)];
    [spacerView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.view addSubview:spacerView];
    
    
    LightningCard* lightningCard = [[LightningCard alloc] init];
    
    // insert dummy hand
    for (int i = 0; i < 5; i++) {
        int x = i*width + i*gutter + handSideGutter;
        int y = viewHeight - (height + topGutter);
        
        GameCardView* newCard = [[GameCardView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [newCard setGameCard:lightningCard];
        
        [handCardViews addObject:newCard];
        [self.view addSubview:newCard];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
