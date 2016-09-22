//
//  MatchStore.h
//  BattleCards
//
//  Created by Drew Fitzpatrick on 4/4/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalMatch.h"

@interface MatchStore : NSObject

+(MatchStore*)sharedStore;

-(LocalMatch*)createLocalMatch;
//-(RemoteMatch*)createRemoteMatch;

-(void)deleteLocalMatch:(LocalMatch*)match;
//-(void)deleteRemoteMatch:(RemoteMatch*)match;

//-(LocalMatch*)getLocalMatchAtIndex:(NSUInteger)index;
-(LocalMatch*)getInProgressLocalMatchAtIndex:(NSUInteger)index;
-(LocalMatch*)getCompletedLocalMatchAtIndex:(NSUInteger)index;
//-(RemoteMatch*)getRemoteMatchAtIndex:(NSUInteger)index;

//-(NSUInteger)localMatchCount;
-(NSUInteger)inProgressLocalMatchCount;
-(NSUInteger)completedLocalMatchCount;

//-(NSUInteger)remoteMatchCount;
-(NSUInteger)inProgressRemoteMatchCount;
-(NSUInteger)completedRemoteMatchCount;

//-(NSUInteger)matchCount;

-(void)clearStorage;

-(void)loadFromArchive;
-(void)archiveToFile;

@end
