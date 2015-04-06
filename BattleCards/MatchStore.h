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

-(LocalMatch*)getLocalMatchAtIndex:(NSUInteger)index;
//-(RemoteMatch*)getRemoteMatchAtIndex:(NSUInteger)index;

-(void)loadFromArchive;
-(void)archiveToFile;

-(NSUInteger)localMatchCount;
-(NSUInteger)remoteMatchCount;
-(NSUInteger)matchCount;

@end
