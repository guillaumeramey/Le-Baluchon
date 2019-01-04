import Foundation

struct Change: Decodable {
    enum Currency: String {
        case euro = "EUR"
        case dollarUS = "USD"
    }

    var rates: [String : Float]
    private var date: String

    // formats the date for display
    var dateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-M-d"

        guard let date = dateFormatter.date(from: date) else {
            return "Impossible de formater la date"
        }

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "FR-fr")

        return dateFormatter.string(from: date)
    }

    // convert an amount from a currency to another
    func convert(_ amount: String?, from sourceCurrency: Currency, to targetCurrency: Currency) -> String {
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
            return String(format: "%.3f", amountFloat * 1 / currencyRate)
        } else {
            guard let currencyRate = rates[targetCurrency.rawValue] else {
                return ""
            }
            return String(format: "%.3f", amountFloat * currencyRate)
        }
    }
}
