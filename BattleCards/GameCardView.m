//
//  GameCardView.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 3/21/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "GameCardView.h"

@interface GameCardView ()
@property (strong, nonatomic) GameCard* card;
@property (strong, nonatomic) UIImageView* iconView;
@property (strong, nonatomic) UILabel* scoreView;
@end

@implementation GameCardView {
    BOOL iconToggle;
}

-(void) setupViews {
    self.iconView = [[UIImageView alloc] init];
    self.scoreView = [[UILabel alloc] init];
    
    CGRect frame = self.frame;
    
    frame.origin = CGPointMake(0, 0);
    
    self.iconView.frame = frame;
    self.scoreView.frame = frame;
    
    self.scoreView.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.iconView];
    [self addSubview:self.scoreView];
    
    iconToggle = YES;
    self.scoreView.alpha = 0.0;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)setGameCard:(GameCard *)card {
    if (card == nil) return;
    
    self.card = card;
    self.iconView.image = [UIImage imageNamed:self.card.iconName];
    self.scoreView.text = [NSString stringWithFormat:@"%d", self.card.score];
    
    [self setNeedsDisplay];
}

-(GameCard*) getGameCard {
    return self.card;
}

-(void)showIcon {
    if (!iconToggle) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scoreView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.5 animations:^{
                self.iconView.alpha = 1.0;
            }];
        }];
    }
    iconToggle = YES;
}

-(void)showScore {
    if (iconToggle) {
        [UIView animateWithDuration:0.5 animations:^{
            self.iconView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.5 animations:^{
                self.scoreView.alpha = 1.0;
            }];
        }];
    }
    iconToggle = NO;
}

@end
