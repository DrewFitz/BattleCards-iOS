//
//  SettingsViewController.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 5/6/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "SettingsViewController.h"
#import "MatchStore.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearStorageAction:(id)sender {
    [[MatchStore sharedStore] clearStorage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
