//
//  CurrentGamesViewController.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/5/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "CurrentGamesViewController.h"
#import "BattleViewController.h"
#import "MatchStore.h"

@implementation CurrentGamesViewController {
}
- (IBAction)addButtonAction:(id)sender {
    [[MatchStore sharedStore] createLocalMatch];
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray* titles = @[@"Local", @"Online"];
    return titles[section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [[MatchStore sharedStore] localMatchCount];
    } else if (section == 1) {
        return [[MatchStore sharedStore] remoteMatchCount];
    } else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InProgressCell"];
    if ([indexPath indexAtPosition:0] == 0) {
        LocalMatch* match = [[MatchStore sharedStore] getLocalMatchAtIndex:[indexPath indexAtPosition:1]];
        cell.textLabel.text = match.matchID;
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocalMatch* match = [[MatchStore sharedStore] getLocalMatchAtIndex:[indexPath indexAtPosition:1]];
        [[MatchStore sharedStore] deleteLocalMatch:match];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell* cell = (UITableViewCell*) sender;
    
    if (cell == nil) {
        NSLog(@"failed to load match");
        return;
    }
    
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    
    LocalMatch* selectedLocalMatch = [[MatchStore sharedStore] getLocalMatchAtIndex:[path indexAtPosition:1]];
    
    BattleViewController* bvc = (BattleViewController*) [segue destinationViewController];
    if (bvc) {
        bvc.delegate = self;
        if (selectedLocalMatch == nil) {
            NSLog(@"match = nil");
        } else {
            NSLog(@"match found");
        }
        bvc.match = selectedLocalMatch;
    }
}

-(void)didCloseBattle {
    [self dismissViewControllerAnimated:YES completion:^{
        [[MatchStore sharedStore] archiveToFile];
    }];
}

@end
