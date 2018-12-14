import Foundation

struct Change: Codable {
    enum Currency: String {
        case euro = "EUR"
        case dollarUS = "USD"
    }

    private var rates: [String : Float]
    var date: String

    func convert(_ amount: String?, fromCurrency: Currency, toCurrency: Currency) -> String {
        guard let amountString = amount else {
            return ""
        }

        guard let amountFloat = Float(amountString) else {
            return ""
        }

        if toCurrency == .euro {
            guard let currencyRate = rates[fromCurrency.rawValue] else {
                return ""
            }
            return String(amountFloat * 1 / currencyRate)
        } else {
            guard let currencyRate = rates[toCurrency.rawValue] else {
                return ""
            }
            return String(amountFloat * currencyRate)
        }
    }
}
