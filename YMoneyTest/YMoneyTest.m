//
//  HomeWork1Tests.m
//  HomeWork1Tests
//
//  Created by Дмитрий on 12.10.15.
//  Copyright (c) 2015 DMA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Cash.h"
#import "YANBalance.h"
#import "YANCashOperation.h"
#import "YANOperationHistory.h"
#import "YANKeyStorage.h"

@interface YANYMoneyTests : XCTestCase

@end

@implementation YANYMoneyTests

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
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testImpossibleToCreateNUllCash {

    XCTAssertThrows([Cash init]);


    float badValue = -1;
    XCTAssertThrows([[Cash alloc] initWithCashCount:badValue currency:@"Р"]);

    NSString * badName = nil;
    XCTAssertThrows([[Cash alloc] initWithCashCount:5 currency:badName]);
}

- (void)testImpossibleToCreateNullBalance {
    Cash *badCash = nil;
    XCTAssertThrows([[Balance alloc] initWithCash:badCash]);
    XCTAssertThrows([[Balance alloc] init]);
}

- (void)testImpossibleToCreateNullCashOperation {

    NSDate *badDate = nil;
    NSString *badDescription = nil;
    Cash *cash = nil;
    
    XCTAssertThrows([[YANCashOperation alloc] initOperationWithDate:badDate description:badDescription cash:cash direction:1]);
    XCTAssertThrows([YANCashOperation new]);
}

- (void)testImpossibleToAddNUllOperation {

    YANOperationHistory *history = [YANOperationHistory new];
    YANCashOperation *badoperation = nil;

    XCTAssertThrows([history addOperation:badoperation]);

}

- (void)testImpossibleToChangeCurrencyAfterInitialization {

    NSMutableString *evilName = [NSMutableString stringWithString:@"Р"];
    Cash *cash = [[Cash alloc] initWithCashCount:100 currency:evilName];
    [evilName setString:@"$"];
    XCTAssertEqualObjects(cash.currency, @"Р");

}

/**
 * KEY Storage Test
 */

- (void)unnableToCreateNullKeyStorage {

//    NSMutableString *evilName = [NSMutableString stringWithString:@"Р"];
//    NSString *badtocken = nil;
//
//    XCTAssertThrows([[YANKeyStorage alloc] init]);
//    XCTAssertThrows([[YANKeyStorage alloc] initWithAccessToken:badtocken]);
//    YANKeyStorage *yanKeyStorage = [[YANKeyStorage alloc]
//            initWithAccessToken:evilName];
//    [evilName setString:@"$"];
//    XCTAssertEqualObjects(yanKeyStorage.accessToken, @"Р");

}
@end
