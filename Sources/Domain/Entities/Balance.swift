//
//  Balance.swift
//  YMoney
//
//  Created by Nikolay Morev on 13/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import Foundation

struct Balance {

    let currentBalance: Cash

    init(cash: Cash) {
        currentBalance = cash
    }

}