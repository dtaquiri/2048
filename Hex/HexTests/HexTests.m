//
//  HexTests.m
//  HexTests
//
//  Created by Michelle Alexander on 3/28/14.
//  Copyright (c) 2014 Michelle Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HXBoard.h"

@interface HexTests : XCTestCase

@property HXBoard *board;

@end

// Expose the board's private methods for testing
@interface HXBoard()

- (CGPoint)indexToLogicalPoint:(NSNumber *)index;
- (NSNumber*)logicalPointToIndex:(CGPoint)point;

@end

@implementation HexTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.board = [[HXBoard alloc]init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIndexToPoint
{
    CGPoint point;
    
    int x[25] = {0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4};
    int y[25] = {0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4};
    
    for (int i = 0; i < 25; i++) {
        NSNumber *index = [NSNumber numberWithInt:i];
        point = [self.board indexToLogicalPoint:index];
        XCTAssertEqual(point.x, x[i], @"Correct X");
        XCTAssertEqual(point.y, y[i], @"Correct Y");
    }
}

- (void)testPointToIndex
{
    CGPoint point;
    
    int x[25] = {0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4,0,1,2,3,4};
    int y[25] = {0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4};
    
    for (int i = 0; i < 25; i++) {
        point = CGPointMake(x[i], y[i]);
        NSNumber *index = [self.board logicalPointToIndex:point];
        XCTAssertEqual(index.integerValue, i, @"Correct integer");
    }
}

@end
