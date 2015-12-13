//
//  CashOperation.swift
//  YMoney
//
//  Created by Nikolay Morev on 13/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import Foundation

enum OperationDirection {
    case In
    case Out
}

struct CashOperation {

    let operationDate: NSDate
    let operationDescription: String
    let operationSum: Cash
    let operationDirection: OperationDirection

    init(operationDate: NSDate, operationDescription: String, operationSum: Cash, operationDirection: OperationDirection) {
        self.operationDate = operationDate
        self.operationDescription = operationDescription
        self.operationSum = operationSum
        self.operationDirection = operationDirection
    }

}