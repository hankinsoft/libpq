//
//  libpqTests.m
//  libpqTests
//
//  Created by kylehankinson on 2018-07-23.
//  Copyright © 2018 Kyle Hankinson. All rights reserved.
//

#import <XCTest/XCTest.h>
@import libpq;

@interface libpqTests : XCTestCase

@end

@implementation libpqTests

- (void) setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void) tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testBasic
{
    int pqlibversion = PQlibVersion();
    NSLog(@"PQlibVersion version: %d", pqlibversion);
    PQinitOpenSSL(1,1);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
