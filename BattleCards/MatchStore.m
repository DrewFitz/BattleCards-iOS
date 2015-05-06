//
//  MatchStore.m
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/4/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import "MatchStore.h"

@interface MatchStore ()

@property (nonatomic, strong) NSMutableArray* localMatches;
@property (nonatomic, strong) NSMutableArray* remoteMatches;

@end

@implementation MatchStore

#pragma mark - Singleton

+(MatchStore *)sharedStore {
    static MatchStore* store = nil;
    if (store == nil) {
        store = [[MatchStore alloc] init];
    }
    return store;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.localMatches = [[NSMutableArray alloc] init];
        self.remoteMatches = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Data Access

-(LocalMatch*)createLocalMatch {
    LocalMatch* localMatch = [[LocalMatch alloc] init];
    localMatch.matchID = [[NSUUID UUID] UUIDString];
    
    [self.localMatches addObject:localMatch];
    
    [self archiveToFile];
    
    return localMatch;
}

//-(RemoteMatch*)createRemoteMatch;

-(void)deleteLocalMatch:(LocalMatch *)match {
    [self.localMatches removeObject:match];
    [self archiveToFile];
}

//-(void)deleteRemoteMatch:(RemoteMatch*)match;

-(LocalMatch *)getLocalMatchAtIndex:(NSUInteger)index {
    return [self.localMatches objectAtIndex:index];
}

-(NSArray*)getInProgressLocalMatches {
    __block NSMutableArray* inProgressMatches = [[NSMutableArray alloc] init];
    [self.localMatches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LocalMatch* match = (LocalMatch*) obj;
        if (match.completed == NO) {
            [inProgressMatches addObject:match];
        }
    }];
    
    return inProgressMatches;
}

-(NSArray*)getCompletedLocalMatches {
    __block NSMutableArray* completedMatches = [[NSMutableArray alloc] init];
    [self.localMatches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LocalMatch* match = (LocalMatch*) obj;
        if (match.completed == YES) {
            [completedMatches addObject:match];
        }
    }];
    
    return completedMatches;
}

-(LocalMatch*)getInProgressLocalMatchAtIndex:(NSUInteger)index {
    NSArray* inProgressMatches = [self getInProgressLocalMatches];
    return [inProgressMatches objectAtIndex:index];
}

-(LocalMatch*)getCompletedLocalMatchAtIndex:(NSUInteger)index {
    NSArray* completedMatches = [self getCompletedLocalMatches];
    return [completedMatches objectAtIndex:index];
}

-(NSUInteger)localMatchCount {
    return [self.localMatches count];
}
-(NSUInteger)inProgressLocalMatchCount {
    return [[self getInProgressLocalMatches] count];
}
-(NSUInteger)completedLocalMatchCount {
    return [[self getCompletedLocalMatches] count];
}

-(NSUInteger)remoteMatchCount {
    return [self.remoteMatches count];
}
-(NSUInteger)inProgressRemoteMatchCount {
    return 0; // TODO
}
-(NSUInteger)completedRemoteMatchCount {
    return 0; // TODO
}

-(NSUInteger)matchCount {
    return [self.remoteMatches count] + [self.localMatches count];
}

#pragma mark - Archiving methods

-(void)loadFromArchive {
    NSFileManager* manager = [NSFileManager defaultManager];
    NSURL* docURL = [manager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL* archiveFile = [NSURL URLWithString:@"localMatchArchive" relativeToURL:docURL];
    
    NSData* data = [NSData dataWithContentsOfURL:archiveFile];
    if (data) {
        NSLog(@"loading archive");
        NSKeyedUnarchiver* unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.localMatches = [unArchiver decodeObjectForKey:@"localMatches"];
        self.remoteMatches = [unArchiver decodeObjectForKey:@"remoteMatches"];
        [unArchiver finishDecoding];
    } else {
        NSLog(@"unable to load archive");
    }
}

-(void)archiveToFile {
    NSFileManager* manager = [NSFileManager defaultManager];
    NSURL* docURL = [manager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSURL* archiveFile = [NSURL URLWithString:@"localMatchArchive" relativeToURL:docURL];
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.localMatches forKey:@"localMatches"];
    [archiver encodeObject:self.remoteMatches forKey:@"remoteMatches"];
    [archiver finishEncoding];
    
    BOOL success = [data writeToURL:archiveFile atomically:YES];
    if (success) {
        NSLog(@"archive successful");
    } else {
        NSLog(@"archive failed");
    }
}

@end
