//
//  Currency.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 03/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import UIKit

let euro = Currency(name: "Euro", symbol: "EUR", icon: "flag_EUR", unit: "€")
let dollarUS = Currency(name: "Dollar US", symbol: "USD", icon: "flag_USD", unit: "$")

let currencies = [euro, dollarUS]

class Currency {
    let name: String
    let symbol: String
    let unit: String
    let icon: UIImage?
    var rate: Float = 1

    init(name: String, symbol: String, icon: String, unit: String) {
        self.name = name
        self.symbol = symbol
        self.icon = UIImage(named: icon) ?? nil
        self.unit = unit
    }
}
