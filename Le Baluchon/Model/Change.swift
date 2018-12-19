import Foundation

struct Change: Decodable {
    enum Currency: String {
        case euro = "EUR"
        case dollarUS = "USD"
    }

    private var rates: [String : Float]
    var date: String

    func convert(_ amount: String?, sourceCurrency: Currency, targetCurrency: Currency) -> String {
        guard let amountString = amount else {
            return ""
        }

        guard let amountFloat = Float(amountString) else {
            return ""
        }

        if targetCurrency == .euro {
            guard let currencyRate = rates[sourceCurrency.rawValue] else {
                return ""
            }
            return String(amountFloat * 1 / currencyRate)
        } else {
            guard let currencyRate = rates[targetCurrency.rawValue] else {
                return ""
            }
            return String(amountFloat * currencyRate)
        }
    }
}
