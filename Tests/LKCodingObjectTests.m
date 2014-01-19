//
//  LKCodingObjectTests.m
//  LKCodingObjectTests
//
//  Created by Hiroshi Hashiguchi on 2014/01/18.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestObject.h"
#import "TestObjectSub.h"

@interface LKCodingObjectTests : XCTestCase

@end

@implementation LKCodingObjectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testArchivingTestObject
{
    TestObject* src = TestObject.new;
    src.boolValue = YES;
    src.integerValue = -1000;
    src.floatValue = -2000.0;
    src.doubleValue = -3000.0;
    
    src.stringValue = @"Hello";
    src.arrayValue = @[@(1), @(2), @(3)];
    src.dictionaryValue = @{@"KEY1":@"VALUE1", @"KEY2":@"VALUE2", @"KEY3":@"VALUE3"};
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:src];
    TestObject* dst = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqual(dst.boolValue, YES, @"");
    XCTAssertEqual(dst.integerValue, -1000, @"");
    XCTAssertEqual(dst.floatValue, -2000.0f, @"");
    XCTAssertEqual(dst.doubleValue, -3000.0, @"");
    
    XCTAssertEqualObjects(dst.stringValue, @"Hello", @"");
    
    NSArray* arrayValue = dst.arrayValue;
    XCTAssertEqual(arrayValue[0], @(1), @"");
    XCTAssertEqual(arrayValue[1], @(2), @"");
    XCTAssertEqual(arrayValue[2], @(3), @"");
    
    NSDictionary* dictionaryValue = dst.dictionaryValue;
    XCTAssertEqualObjects(dictionaryValue[@"KEY1"], @"VALUE1", @"");
    XCTAssertEqualObjects(dictionaryValue[@"KEY2"], @"VALUE2", @"");
    XCTAssertEqualObjects(dictionaryValue[@"KEY3"], @"VALUE3", @"");
}

- (void)testArchivingTestObjectSub
{
    TestObjectSub* src = TestObjectSub.new;
    src.boolValue = YES;
    src.integerValue = -1000;
    src.floatValue = -2000.0;
    src.doubleValue = -3000.0;
    
    src.stringValue = @"Hello";
    src.arrayValue = @[@(1), @(2), @(3)];
    src.dictionaryValue = @{@"KEY1":@"VALUE1", @"KEY2":@"VALUE2", @"KEY3":@"VALUE3"};
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:src];
    TestObject* dst = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqual(dst.boolValue, YES, @"");
    XCTAssertEqual(dst.integerValue, -1000, @"");
    XCTAssertEqual(dst.floatValue, -2000.0f, @"");
    XCTAssertEqual(dst.doubleValue, -3000.0, @"");
    
    XCTAssertEqualObjects(dst.stringValue, @"Hello", @"");
    
    NSArray* arrayValue = dst.arrayValue;
    XCTAssertEqual(arrayValue[0], @(1), @"");
    XCTAssertEqual(arrayValue[1], @(2), @"");
    XCTAssertEqual(arrayValue[2], @(3), @"");
    
    NSDictionary* dictionaryValue = dst.dictionaryValue;
    XCTAssertEqualObjects(dictionaryValue[@"KEY1"], @"VALUE1", @"");
    XCTAssertEqualObjects(dictionaryValue[@"KEY2"], @"VALUE2", @"");
    XCTAssertEqualObjects(dictionaryValue[@"KEY3"], @"VALUE3", @"");
}

- (void)testEmpty
{
    TestObject* src = TestObject.new;

    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:src];
    TestObject* dst = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    XCTAssertEqual(dst.boolValue, NO, @"");
    XCTAssertEqual(dst.integerValue, 0, @"");
    XCTAssertEqual(dst.floatValue, 0.0f, @"");
    XCTAssertEqual(dst.doubleValue, 0.0, @"");
    XCTAssertNil(dst.stringValue, @"");
    XCTAssertNil(dst.arrayValue, @"");
    XCTAssertNil(dst.dictionaryValue, @"");
}

- (void)testNotArching
{
    TestObject* src = TestObject.new;
    src.urlCache = NSURLCache.sharedURLCache;
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:src];
    TestObject* dst = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertNil(dst.urlCache, @"");
    
}


@end
