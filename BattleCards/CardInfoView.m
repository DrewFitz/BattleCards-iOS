//
//  CardInfoView.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 5/5/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "CardInfoView.h"

@implementation CardInfoView {
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UILabel *cardNameLabel;
    __weak IBOutlet UILabel *pointsLabel;
    __weak IBOutlet UILabel *descriptionLabel;
}

-(void)setCard:(GameCard *)card {
    cardNameLabel.text = card.name;
    iconImageView.image = [UIImage imageNamed:card.iconName];
    iconImageView.tintColor = card.tintColor;
    pointsLabel.text = [NSString stringWithFormat:@"%d points", card.score];
    descriptionLabel.text = card.effectDescription;
    
    [self invalidateIntrinsicContentSize];
    [self layoutSubviews];
}

@end
