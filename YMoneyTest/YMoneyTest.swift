//
//  YMoneyTest.swift
//  YMoney
//
//  Created by Nikolay Morev on 13/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import XCTest
@testable import YMoney

class YMoneyTest: XCTestCase {

    // Тест на вызов запрещенного инициализатора init не нужен, т.к. у Cash просто нет такого метода.

    // В XCTest пока нет XCTAssertThrows, кроме того assert в Swift не выбрасывает исключение,
    // а просто вызывает крэш, поэтому нет простого способа протестировать

//    func testImpossibleToCreateNullCash() {
//
//        Cash()
//
//        let badValue: Float = -1
//        Cash(count: badValue, currency: "P")
//
//        let badName = ""
//        Cash(count: 5, currency: badName)
//    }

    // Тест не передачу nil не нужен, т.к. это отлавливается компилятором

//    func testImpossibleToCreateNullBalance() {
//        let badCash: Cash? = nil
//        Balance(cash: badCash);
//    }

    func testImpossibleToCreateNullCashOperation() {
//        NSDate *badDate = nil;
//        NSString *badDescription = nil;
//        Cash *cash = nil;
//        XCTAssertThrows([[YANCashOperation alloc] initOperationWithDate:badDate description:badDescription cash:cash direction:1]);
//        XCTAssertThrows([YANCashOperation new]);
    }

    func testImpossibleToAddNullOperation() {
//        YANOperationHistory *history = [YANOperationHistory new];
//        YANCashOperation *badoperation = nil;
//        XCTAssertThrows([history addOperation:badoperation]);
    }

    func testImpossibleToChangeCurrencyAfterInitialization() {
        // Тест не нужен, т.к. value-типы всегда передаются как копия

        var evilName: String? = "P"
        let cash = Cash(count: 100, currency: evilName!)
        evilName = nil
        XCTAssertEqual(cash.currency, "P")
    }

//    /**
//    * KEY Storage Test
//    */
//
//    - (void)unnableToCreateNullKeyStorage {
//
//    //    NSMutableString *evilName = [NSMutableString stringWithString:@"Р"];
//    //    NSString *badtocken = nil;
//    //
//    //    XCTAssertThrows([[YANKeyStorage alloc] init]);
//    //    XCTAssertThrows([[YANKeyStorage alloc] initWithAccessToken:badtocken]);
//    //    YANKeyStorage *yanKeyStorage = [[YANKeyStorage alloc]
//    //            initWithAccessToken:evilName];
//    //    [evilName setString:@"$"];
//    //    XCTAssertEqualObjects(yanKeyStorage.accessToken, @"Р");
//    
//    }

}
