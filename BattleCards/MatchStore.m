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
        // TODO: load from file
        self.localMatches = [[NSMutableArray alloc] init];
        self.remoteMatches = [[NSMutableArray alloc] init];
    }
    return self;
}

-(LocalMatch*)createLocalMatch {
    LocalMatch* localMatch = [[LocalMatch alloc] init];
    localMatch.matchID = [[NSUUID UUID] UUIDString];
    
    [self.localMatches addObject:localMatch];
    
    return localMatch;
}

//-(RemoteMatch*)createRemoteMatch;

-(void)deleteLocalMatch:(LocalMatch *)match {
    [self.localMatches removeObject:match];
}

//-(void)deleteRemoteMatch:(RemoteMatch*)match;

-(LocalMatch *)getLocalMatchAtIndex:(NSUInteger)index {
    return [self.localMatches objectAtIndex:index];
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

-(NSUInteger)localMatchCount {
    return [self.localMatches count];
}
-(NSUInteger)remoteMatchCount {
    return [self.remoteMatches count];
}
-(NSUInteger)matchCount {
    return [self.remoteMatches count] + [self.localMatches count];
}

@end
