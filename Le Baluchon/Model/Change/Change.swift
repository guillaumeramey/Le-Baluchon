//
//  Change.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

class Change {

    enum Currency: String {
        case euro = "EUR"
        case dollarUS = "USD"
    }

    var date: Date
    var rates: [String : Float]

    init(date: Date, rates: [String : Float]) {
        self.date = date
        self.rates = rates
    }

    func convert(_ amount: String?, from sourceCurrency: Currency, to targetCurrency: Currency) -> String {

        guard let amountString = amount else {
            return ""
        }

        // Bug with the decimal separator on the pad
        guard let amountFloat = Float(amountString.replacingOccurrences(of: ",", with: ".")) else {
            return ""
        }

        if targetCurrency == .euro {
            guard let currencyRate = rates[sourceCurrency.rawValue] else {
                return ""
            }
            return String(format: "%.3f", amountFloat * 1 / currencyRate)
        } else {
            guard let currencyRate = rates[targetCurrency.rawValue] else {
                return ""
            }
            return String(format: "%.3f", amountFloat * currencyRate)
        }
    }

    // formats the date for display
    func displayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "FR-fr")

        return dateFormatter.string(from: date)
    }
}
