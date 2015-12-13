//
//  OperationHistory.swift
//  YMoney
//
//  Created by Nikolay Morev on 13/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import Foundation

class OperationHistory {

    private var operations: [CashOperation] = []

    func add(operation: CashOperation) {
        operations.append(operation)
    }

}
