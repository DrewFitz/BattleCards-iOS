//
//  BattleViewController.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "BattleViewController.h"
#import "GridSlotView.h"
#import "CardInfoView.h"
#import "GameCardView.h"
#import "AnimationCoordinator_InternalAccess.h"
#import "NullCard.h"

#define HAND_CARDS (3)

@interface BattleViewController ()
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;
@property (weak, nonatomic) IBOutlet CardInfoView *cardInfoView;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;

@end

@implementation BattleViewController {
    GridSlotView* gridSlotViews[16];
    GridSlotView* handSlotViews[HAND_CARDS];
    
    GridSlotView* hilightedSlot;
    GridSlotView* oldSlot;
    
    UIView* spacerView;
    
    GameCardView* currentDraggingView;
    
    UITouch* draggingTouch;
    
    NSMutableArray* pendingAnimations;
    
    BOOL _shouldShowOpponentActions;
}


#pragma mark - Helper methods

-(GridSlotView*)closestViewToPoint:(CGPoint)point {
    float minDistance = powf(95.0, 2);
    GridSlotView* closestSlot = nil;
    
    for (int i = 0; i < HAND_CARDS; i++) {
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
    
    for (int i = 8; i < 16; i++) {
        GridSlotView* slot = gridSlotViews[i];
        
        GameBoardRow row = slot.gridY == 2 ? GameBoardRowAction : GameBoardRowScore;
        GameBoardSlotState state = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:row slot:slot.gridX];
        
        if (state == GameBoardSlotStateActive) {
            continue;
        }
        
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
    
    GameBoardRow row = closestSlot.gridY == 2 ? GameBoardRowAction : GameBoardRowScore;
    GameBoardSlotState state = [[GameBoard sharedBoard] getStateForPlayer:GameBoardPlayerLocal inRow:row slot:closestSlot.gridX];
    if (state == GameboardSlotStateInactive) {
        return nil;;
    }
    
    return closestSlot;
}

-(void)drawHand {
    for (int i = 0; i < HAND_CARDS; i++) {
        UIView* view = handSlotViews[i].targetView;
        if (view) {
            [view removeFromSuperview];
            handSlotViews[i].targetView = nil;
        }
    }
    
    for (int i = 0; i < HAND_CARDS; i++) {
        GameCard* card = [[GameBoard sharedBoard] drawCard];
        GameCardView* cardView = [[GameCardView alloc] init];
        cardView.delegate = self;
        [self.view addSubview:cardView];
        [cardView setGameCard:card];
        [handSlotViews[i] setTargetView:cardView];
    }
}

-(void)writeToGameBoard {
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

-(void)reloadBoard {
    for (int i = 0; i < 16; i++) {
        UIView* view = gridSlotViews[i].targetView;
        if (view) {
            [view removeFromSuperview];
            gridSlotViews[i].targetView = nil;
        }
    }
    
    GameBoard* board = [GameBoard sharedBoard];
    
    // opponent score
    for (int i = 0; i < 4; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:i%4];
        if (state != GameBoardSlotStateEmpty) {
            GameCardView* view = [[GameCardView alloc] init];
            view.delegate = self;
            GameCard* card = [board getCardForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowScore slot:i%4];
            [view setGameCard:card];
            [view showScore];
            [self.view addSubview:view];
            gridSlotViews[i].targetView = view;
        }
    }
    // opponent action
    for (int i = 4; i < 8; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:i%4];
        if (state != GameBoardSlotStateEmpty) {
            GameCardView* view = [[GameCardView alloc] init];
            view.delegate = self;
            GameCard* card;
            if (_shouldShowOpponentActions || state == GameboardSlotStateInactive) {
                card = [board getCardForPlayer:GameBoardPlayerOpponent inRow:GameBoardRowAction slot:i%4];
            } else {
                card = [[NullCard alloc] init];
            }
            [view setGameCard:card];
            [view showIcon];
            [view setActive:state == GameBoardSlotStateActive];
            [self.view addSubview:view];
            gridSlotViews[i].targetView = view;
        }
    }
    // player action
    for (int i = 8; i < 12; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:i%4];
        if (state != GameBoardSlotStateEmpty) {
            GameCardView* view = [[GameCardView alloc] init];
            view.delegate = self;
            GameCard* card = [board getCardForPlayer:GameBoardPlayerLocal inRow:GameBoardRowAction slot:i%4];
            [view setGameCard:card];
            [view showIcon];
            [view setActive:state == GameBoardSlotStateActive];
            [self.view addSubview:view];
            gridSlotViews[i].targetView = view;
        }
    }
    // player score
    for (int i = 12; i < 16; i++) {
        GameBoardSlotState state = [board getStateForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:i%4];
        if (state != GameBoardSlotStateEmpty) {
            GameCardView* view = [[GameCardView alloc] init];
            view.delegate = self;
            GameCard* card = [board getCardForPlayer:GameBoardPlayerLocal inRow:GameBoardRowScore slot:i%4];
            [view setGameCard:card];
            [view showScore];
            [self.view addSubview:view];
            gridSlotViews[i].targetView = view;
        }
    }
}

-(void)playPendingAnimations {
    //TODO
}

-(void)hideHand {
    for (int i = 0; i < HAND_CARDS; i++) {
        [handSlotViews[i].targetView setHidden:YES];
        [handSlotViews[i] setHidden:YES];
    }
}

-(void)showWinner{
    int winner = 0;
    GameBoardPlayer w = [[GameBoard sharedBoard] winner];
    if ([[GameBoard sharedBoard] turnOrder] == GameBoardTurnOrderLocalFirst) {
        winner = w == GameBoardPlayerLocal ? 1 : 2;
    } else {
        winner = w == GameBoardPlayerLocal ? 2 : 1;
    }
    self.winnerLabel.text = [NSString stringWithFormat:@"Player %d wins", winner];
    [self.winnerLabel setHidden:NO];
}

-(void)startTurn {
    [self reloadBoard];
    if (_match.completed) {
        [self hideHand];
        [self showWinner];
        [self.downSwipeRecognizer setEnabled:NO];
    } else {
        [self drawHand];
    }
}

-(void)endTurn {
    // write our data from UI into the model
    [self writeToGameBoard];
    
    // tell model to process changes
    [self.match commitTurn];
    
    // show changes
    [self playPendingAnimations];
    
    // show blocking view for player change
    [self showBlockingView];
}

#pragma mark - Accessory View Functions

-(void) showBlockingView {
    int playerNumber = [GameBoard sharedBoard].turnOrder == GameBoardTurnOrderLocalFirst ? 1 : 2;
    self.turnPassMessageLabel.text = [NSString stringWithFormat:@"Pass Device to Player %d and tap to continue.", playerNumber];
    [self.turnBlockingView setHidden:NO];
    [self.view bringSubviewToFront:self.turnBlockingView];
    [UIView animateWithDuration:0.2 animations:^{
        self.turnBlockingView.alpha = 1.0;
    }];
    
    [self.tapRecognizer setEnabled:YES];
    
}

-(void) dismissBlockingView {
    [self.tapRecognizer setEnabled:NO];
    [UIView animateWithDuration:0.2 animations:^{
        self.turnBlockingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.turnBlockingView setHidden:YES];
        [self startTurn];
    }];
}

-(void) showInfoView:(GameCard*)card {
    [self.cardInfoView setCard:card];
    
    [self.view bringSubviewToFront:self.cardInfoView];
    
    [self.cardInfoView setHidden:NO];
    
    self.cardInfoView.alpha = 0.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.cardInfoView.alpha = 1.0;
    }];
    
    [self.infoTapGestureRecognizer setEnabled:YES];
}

-(void) dismissInfoView {
    self.cardInfoView.alpha = 1.0;
    [UIView animateWithDuration:0.15 animations:^{
        self.cardInfoView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.cardInfoView setHidden:YES];
    }];
    
    [self.infoTapGestureRecognizer setEnabled:NO];
}


#pragma mark - Touch Handling

- (IBAction)pinchEvent:(id)sender {
    UIPinchGestureRecognizer* pg = (UIPinchGestureRecognizer*)sender;
    if (pg && [pg scale] < 0.5) {
        [self.delegate didCloseBattle];
    }
}

- (IBAction)downSwipeEvent:(id)sender {
    [self endTurn];
}

- (IBAction)blockingTapEvent:(id)sender {
    [self dismissBlockingView];
}

- (IBAction)infoTapEvent:(id)sender {
    [self dismissInfoView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingTouch != nil) {
        return;
    }
    
    if (self.infoTapGestureRecognizer.enabled == YES) {
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
        } else {
            draggingTouch = nil;
        }
    }
    
    if (currentDraggingView) {
        [self.view bringSubviewToFront:currentDraggingView];
        [UIView animateWithDuration:0.1 animations:^{
            currentDraggingView.alpha = 0.75;
            [currentDraggingView setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
        }];
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
        
        for (int i = 0; i < HAND_CARDS; i++) {
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
        if (currentDraggingView) {
            [UIView animateWithDuration:0.1 animations:^{
                currentDraggingView.alpha = 1.0;
                [currentDraggingView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            }];
        }
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
        if (currentDraggingView) {
            [UIView animateWithDuration:0.1 animations:^{
                currentDraggingView.alpha = 1.0;
                [currentDraggingView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            }];
        }
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
    int handWidth   = width*(HAND_CARDS) + gutter*(HAND_CARDS - 1);
    
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
    
    for (int i = 0; i < HAND_CARDS; i++) {
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
    
    // create hand slots
    for (int i = 0; i < HAND_CARDS; i++) {
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
    
    _shouldShowOpponentActions = NO;
    
    [self.turnBlockingView setHidden:YES];
    [self.cardInfoView setHidden:YES];
    [self.infoTapGestureRecognizer setEnabled:NO];
    
    self.downSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeEvent:)];
    [self.downSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.downSwipeRecognizer setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:self.downSwipeRecognizer];
    
    [self.tapRecognizer setEnabled:NO];
    
    [self allocateBoardViews];
    [self layoutBoardViews];
    
    [self.match makeActiveMatch];
    [GameBoard sharedBoard].delegate = self;
    
    [self.winnerLabel setHidden:YES];
    [self startTurn];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        [self layoutBoardViews];
    } completion:nil];
}


#pragma mark - GameBoardDelegate Protocol

-(void)gameBoardDidEndGame:(GameBoard *)board {
    _match.completed = YES;
}

-(void)gameBoard:(GameBoard *)board didActivateCard:(GameCard *)card forPlayer:(GameBoardPlayer)player inSlot:(int)slot {
    AnimationCoordinator* ac = [[AnimationCoordinator alloc] init];
    
    SourceInfo source;
    source.slot = slot;
    source.row = GameBoardRowAction;
    source.player = player;
    
    [ac setSource:source];
    
    for (int i = 0; i < 16; i++) {
        GridSlotView *slot = gridSlotViews[i];
        [ac setCenter:slot.center forSlotNumber:i];
    }
    
    void(^animBlock)() = [card animationBlockWithCoordinator:ac];
    
    [pendingAnimations addObject:animBlock];
}

#pragma mark - GameCardViewDelegate Protocol

-(void)gameCardViewTapped:(GameCardView *)sender {
    if (![self.cardInfoView isHidden]) {
        return;
    }
    if (![self.turnBlockingView isHidden]) {
        return;
    }
    
    GameCard* card = [sender getGameCard];
    [self showInfoView:card];
}

@end
