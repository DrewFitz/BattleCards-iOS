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

@interface BattleViewController ()

@end

@implementation BattleViewController {
    GridSlotView* gridSlotViews[16];
    GameCardView* gridCardViews[16];
    
    GridSlotView* handSlotViews[5];
    GameCardView* handCardViews[5];
    
    GameCardView* currentDraggingView;
    GridSlotView* hilightedSlot;
    GridSlotView* oldSlot;
    
    GridSlotView* spacerView;
    
    UITouch* draggingTouch;
}


#pragma mark - Helper methods

-(GridSlotView*)closestViewToPoint:(CGPoint)point {
    float minDistance = powf(95.0, 2);
    GridSlotView* closestSlot = nil;
    
    for (int i = 0; i < 5; i++) {
        GridSlotView* slot = handSlotViews[i];
        GameCardView* view = (GameCardView*) slot.targetView;
        if (view == nil) {
            continue;
        }
        float distance = powf(point.x - view.center.x , 2) + powf(point.y - view.center.y, 2);
        if (distance < minDistance) {
            minDistance = distance;
            closestSlot = slot;
        }
    }
    
    if (closestSlot) { // prefer hand over board
        return closestSlot;
    }
    
    for (int i = 0; i < 16; i++) {
        GridSlotView* slot = gridSlotViews[i];
        GameCardView* view = (GameCardView*) slot.targetView;
        if (view == nil) {
            continue;
        }
        float distance = powf( point.x - view.center.x , 2) + powf(point.y - view.center.y, 2);
        if (distance < minDistance) {
            minDistance = distance;
            closestSlot = slot;
        }
        
    }
    
    return closestSlot;
}

-(void)drawHand {
    GameCard* cardType = [[LightningCard alloc] init];
    GameCardView* newCard = [[GameCardView alloc] init];
    [self.view addSubview:newCard];
    [newCard setGameCard:cardType];
    [handSlotViews[0] setTargetView:newCard];
    
    newCard = [[GameCardView alloc] init];
    [self.view addSubview:newCard];
    [newCard setGameCard:cardType];
    [handSlotViews[2] setTargetView:newCard];
    
    newCard = [[GameCardView alloc] init];
    [self.view addSubview:newCard];
    [newCard setGameCard:cardType];
    [handSlotViews[4] setTargetView:newCard];
}

-(void)commitTurn {
    GameBoard* board = [GameBoard sharedBoard];
    
    // actions
    for (int i = 8; i < 12; i++) {
        GridSlotView* slot = gridSlotViews[i];
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot.gridX];
        if (state == GameBoardSlotStateEmpty) {
            GameCardView* card = (GameCardView*) slot.targetView;
            if (card) {
                [board setState:GameBoardSlotStateActive forPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot.gridX];
                [board setCard:[card getGameCard] forPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot.gridX];
            }
        }
    }
    
    // score
    for (int i = 12; i < 16; i++) {
        GridSlotView* slot = gridSlotViews[i];
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot.gridX];
        if (state == GameBoardSlotStateEmpty) {
            GameCardView* card = (GameCardView*) slot.targetView;
            if (card) {
                [board setState:GameBoardSlotStateActive forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot.gridX];
                [board setCard:[card getGameCard] forPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot.gridX];
            }
        }
    }
}


#pragma mark - UIGestureRecognizerDelegate protocol

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // TODO: handle gestures only for compact view sizes
    return NO;
}


#pragma mark - Touch Handling

- (IBAction)downSwipeEvent:(id)sender {
}

- (IBAction)upSwipeEvent:(id)sender {
}

- (IBAction)tapEvent:(id)sender {
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingTouch != nil) {
        return;
    }
    
    draggingTouch = [touches anyObject];
    if (draggingTouch) {
        CGPoint touchLocation = [draggingTouch locationInView:self.view];
        GridSlotView* closestSlot = [self closestViewToPoint:touchLocation];
        GameCardView* closestView = (GameCardView*) closestSlot.targetView;
        
        if (closestView) {
            closestSlot.targetView = nil;
            currentDraggingView = closestView;
            oldSlot = closestSlot;
            [UIView animateWithDuration:0.25 animations:^{
                [currentDraggingView showIcon];
            }];
        } else {
            draggingTouch = nil;
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:draggingTouch]) {
        CGPoint touchLocation = [draggingTouch locationInView:self.view];
        
        GridSlotView* closestView = nil;
        float minDistance = powf(95.0, 2);
        
        UIColor* inactiveBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        UIColor* activeBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        for (int i = 8; i < 16; i++) {
            GridSlotView* view = gridSlotViews[i];
            float distance = powf(touchLocation.x - view.center.x, 2) + powf(touchLocation.y - view.center.y, 2);
            if (distance < minDistance) {
                minDistance = distance;
                closestView = view;
            }
            [view setBackgroundColor:inactiveBackgroundColor];
        }
        
        for (int i = 0; i < 5; i++) {
            GridSlotView* view = handSlotViews[i];
            float distance = powf(touchLocation.x - view.center.x, 2) + powf(touchLocation.y - view.center.y, 2);
            if (distance < minDistance) {
                minDistance = distance;
                closestView = view;
            }
            [view setBackgroundColor:inactiveBackgroundColor];
        }
        
        [closestView setBackgroundColor:activeBackgroundColor];
        hilightedSlot = closestView;
        
        currentDraggingView.center = touchLocation;
        
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:draggingTouch]) {
        UIColor* inactiveBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        BOOL showIcon = YES;
        
        // handle drop
        BOOL success = NO;
        if (hilightedSlot) {
            int slot = hilightedSlot.gridX;
            int row = hilightedSlot.gridY;
            
            if (row == 2) { // player action row
                GameBoardSlotState state = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:slot];
                if (state == GameBoardSlotStateEmpty && hilightedSlot.targetView == nil) {
                    success = YES;
                    showIcon = YES;
                }
            } else if (row == 3) { // player score row
                GameBoardSlotState state = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:slot];
                if (state == GameBoardSlotStateEmpty && hilightedSlot.targetView == nil) {
                    success = YES;
                    showIcon = NO;
                }
            } else if (row == 5) { // hand
                if (handSlotViews[slot].targetView == nil) {
                    success = YES;
                    showIcon = YES;
                }
            }
        }
        
        if (success) {
            [UIView animateWithDuration:0.25 animations:^{
                hilightedSlot.targetView = currentDraggingView;
                if (showIcon) {
                    [currentDraggingView showIcon];
                } else {
                    [currentDraggingView showScore];
                }
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                oldSlot.targetView = currentDraggingView;
            }];
        }
        
        [hilightedSlot setBackgroundColor:inactiveBackgroundColor];
        
        hilightedSlot = nil;
        oldSlot = nil;
        draggingTouch = nil;
        currentDraggingView = nil;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches containsObject:draggingTouch]) {
        oldSlot.targetView = currentDraggingView;
        draggingTouch = nil;
        oldSlot = nil;
        currentDraggingView = nil;
    }
}

#pragma mark - Initialize views

- (void)layoutBoardViews {
    
    int viewWidth = self.view.bounds.size.width;
    int viewHeight = self.view.bounds.size.height;
    
    int width  = 60;
    int height = 97;
    int gutter = 10;
    
    int boardWidth  = width*4  + gutter*3;
//    int boardHeight = height*4 + gutter*3 + (verticalSpacer + gutter);
    int handWidth   = width*5 + gutter*4;
    
    int topGutter  = 20;
    int sideGutter = (viewWidth - boardWidth) / 2;
    int handSideGutter = (viewWidth - handWidth) / 2;

    int verticalSpacer = 12;
    
    for (int i = 0; i < 16; i++) {
        GridSlotView* view = gridSlotViews[i];
        int xIndex = view.gridX;
        int yIndex = view.gridY;
        
        int x = sideGutter + xIndex * width + xIndex * gutter;
        int y = topGutter + yIndex * height + yIndex * gutter;
        if (yIndex >= 2) y += verticalSpacer + gutter;
        
        [view setFrame:CGRectMake(x, y, width, height)];
    }
    
    // insert divider line
    int y = topGutter + 2 * height + 2 * gutter;
    [spacerView setFrame:CGRectMake(0, y, viewWidth, verticalSpacer)];
    
    for (int i = 0; i < 5; i++) {
        GridSlotView* view = handSlotViews[i];
        
        int i = view.gridX;
        int x = i*width + i*gutter + handSideGutter;
        int y = viewHeight - (height + topGutter);
        
        [view setFrame:CGRectMake(x, y, width, height)];
    }
}

- (void)allocateBoardViews {
    UIColor* slotBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    // create grid slot views
    for (int i = 0; i < 16; i++) {
        int xIndex = i%4;
        int yIndex = i/4;
        
        GridSlotView* newGridSlot = [[GridSlotView alloc] init];
        [newGridSlot setBackgroundColor:slotBackgroundColor];
        newGridSlot.gridX = xIndex;
        newGridSlot.gridY = yIndex;
        [self.view addSubview:newGridSlot];
        
        gridSlotViews[i] = newGridSlot;
    }
    
    // insert divider line
    spacerView = [[GridSlotView alloc] init];
    [spacerView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.view addSubview:spacerView];
    
    for (int i = 0; i < 5; i++) {
        GridSlotView* newHandSlot = [[GridSlotView alloc] init];
        [newHandSlot setBackgroundColor:slotBackgroundColor];
        newHandSlot.gridX = i;
        newHandSlot.gridY = 5;
        [self.view addSubview:newHandSlot];
        
        handSlotViews[i] = newHandSlot;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GameBoard sharedBoard].delegate = self;
    
    [self allocateBoardViews];
    [self layoutBoardViews];
    
    [self drawHand];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        [self layoutBoardViews];
    } completion:nil];
}


#pragma mark - GameBoardDelegate Protocol

-(void)gameBoardDidChange:(GameBoard *)board {
    NSLog(@"BoardChanged");
}

@end
