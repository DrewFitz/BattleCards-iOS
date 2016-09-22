//
//  BattleCardsTests.m
//  BattleCardsTests
//
//  Created by Drew Fitzpatrick on 3/20/15.
//  Copyright (c) 2015 Drew Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface BattleCardsTests : XCTestCase

@end

@implementation BattleCardsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    NSObject* obj1 = [[NSObject alloc] init];
    NSObject* obj2 = [[NSObject alloc] init];
    
    XCTAssertEqual([obj1 class], [obj2 class], @"class equality");
    XCTAssertEqualObjects([obj1 class], [obj2 class], @"class equality objects");
    
    NSObject* obj3 = [[NSString alloc] init];
    NSObject* obj4 = [[UIResponder alloc] init];
    
    NSLog(@"%@", [obj3 class]);
    NSLog(@"%@", [obj4 class]);
    
    XCTAssertNotEqual([obj3 class], [obj4 class], @"class inequality through parent class pointer");
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
