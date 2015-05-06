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

-(void) wasTapped {
    [self.delegate gameCardViewTapped:self];
}

-(void) setupViews {
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconView = [[UIImageView alloc] init];
    self.scoreView = [[UILabel alloc] init];
    
    CGRect frame = self.frame;
    
    frame.origin = CGPointZero;
    self.scoreView.frame = frame;
    
    frame.origin.y = (frame.size.height - frame.size.width) / 2.0;
    frame.size.height = frame.size.width;
    self.iconView.frame = frame;
    
    self.scoreView.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.iconView];
    [self addSubview:self.scoreView];
    
    UIColor *bgColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    self.iconView.backgroundColor = bgColor;
    self.scoreView.backgroundColor = bgColor;
    self.backgroundColor = bgColor;
    
    UIFont* scoreFont = [UIFont fontWithName:@"Helvetica" size:40.0];
    if (scoreFont) {
        self.scoreView.font = scoreFont;
        self.scoreView.textColor = [UIColor whiteColor];
    }
    
    iconToggle = YES;
    self.scoreView.alpha = 0.0;
    
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wasTapped)];
    [self addGestureRecognizer:tapGR];
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

-(void)setActive:(BOOL)active {
    UIColor *color;
    if (active) {
        color = self.card.tintColor;
    } else {
        color = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    self.iconView.tintColor = color;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    frame.origin = CGPointZero;
    self.scoreView.frame = frame;
    
    frame.origin.y = (frame.size.height - frame.size.width) / 2.0;
    frame.size.height = frame.size.width;
    self.iconView.frame = frame;
}

-(void)setGameCard:(GameCard *)card {
    if (card == nil) return;
    
    self.card = card;
    self.iconView.image = [UIImage imageNamed:self.card.iconName];
    self.iconView.tintColor = self.card.tintColor;
    self.scoreView.text = [NSString stringWithFormat:@"%d", self.card.score];
    
    [self setNeedsDisplay];
}

-(GameCard*) getGameCard {
    return self.card;
}

-(void)showIcon {
    if (!iconToggle) {
        [UIView animateWithDuration:0.25 animations:^{
            self.scoreView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.25 animations:^{
                self.iconView.alpha = 1.0;
            }];
        }];
    }
    iconToggle = YES;
}

-(void)showScore {
    if (iconToggle) {
        [UIView animateWithDuration:0.25 animations:^{
            self.iconView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.25 animations:^{
                self.scoreView.alpha = 1.0;
            }];
        }];
    }
    iconToggle = NO;
}

@end
