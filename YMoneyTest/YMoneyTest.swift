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

    // Тест не передачу nil не нужен, т.к. это отлавливается компилятором

//    func testImpossibleToCreateNullCashOperation() {
//        let badDate: NSDate? = nil
//        let badDescription: String? = nil
//        let cash: Cash? = nil
//
//        CashOperation(operationDate: badDate, operationDescription: badDescription, operationSum: cash, operationDirection: .Out)
//    }

    // Тест не передачу nil не нужен, т.к. это отлавливается компилятором

//    func testImpossibleToAddNullOperation() {
//        let history = OperationHistory()
//        let badOperation: CashOperation? = nil
//        history.add(badOperation)
//    }

    func testImpossibleToChangeCurrencyAfterInitialization() {
        // Тест не нужен, т.к. value-типы всегда передаются как копия

        var evilName: String? = "P"
        let cash = Cash(count: 100, currency: evilName!)
        evilName = nil
        XCTAssertEqual(cash.currency, "P")
    }

    /// KEY Storage Test
//    func testUnableToCreateNullKeyStorage {
//        var evilName: String? = "P"
//        let badToken: String? = nil
//
//        KeyStorage()
//
//        KeyStorage(accessToken: badToken)
//
//        let yanKeyStorage = KeyStorage(accessToken: evilName)
//        evilName = "$"
//        XCTAssertEqual(yanKeyStorage.accessToken, "P")
//    }

}
