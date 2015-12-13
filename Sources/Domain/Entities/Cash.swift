//
//  Cash.swift
//  YMoney
//
//  Created by Nikolay Morev on 13/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import Foundation

struct Cash {

    let currency: String
    let count: Float

    /// - precondition: count >= 0.0
    init(count: Float, currency: String) {
        precondition(count >= 0)
        precondition(currency != "")

        self.count = count
        self.currency = currency
    }

}