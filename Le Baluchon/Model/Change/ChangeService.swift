//
//  ChangeService.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

class ChangeService {
    // singleton pattern
    static var shared = ChangeService()
    private init() {}

    private let apiUrl = "http://data.fixer.io/api/latest"
    private let apiKey = valueForAPIKey("fixer")

    // Store the last update in the user defaults
    private struct Keys {
        static let changeLastUpdate = "changeLastUpdate"
        static let changeLastRates = "changeLastRates"
    }

    static var lastUpdate: Date? {
        get {
            return UserDefaults.standard.object(forKey: Keys.changeLastUpdate) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.changeLastUpdate)
        }
    }

    static var lastRates: [String : Float]? {
        get {
            return UserDefaults.standard.object(forKey: Keys.changeLastRates) as? [String : Float]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.changeLastRates)
        }
    }

    // Compare the last update with the current day
    var isUpdateNeeded: Bool {
        if let lastUpdate = ChangeService.lastUpdate {
            return !Calendar.current.isDate(Date(), equalTo: lastUpdate, toGranularity: .day)
        }
        return true
    }

    private var task: URLSessionDataTask!
    private var changeSession = URLSession.init(configuration: .default)

    init(changeSession: URLSession) {
        self.changeSession = changeSession
    }

    // API request
    func getRates(callback: @escaping (Bool, ChangeJSON?) -> Void) {

        let urlString = apiUrl
            + "?access_key=" + apiKey
            + "&symbols=USD"

        let request = URLRequest(url: URL(string: urlString)!)

        task?.cancel()
        task = changeSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                do {
                    let change = try JSONDecoder().decode(ChangeJSON.self, from: data)
                    ChangeService.lastUpdate = change.getDate
                    ChangeService.lastRates = change.rates
                    callback(true, change)
                } catch {
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }

    // MARK: - Currency conversion
    enum Currency: String {
        case euro = "EUR"
        case dollarUS = "USD"
    }

    func convert(_ amount: String?, from sourceCurrency: Currency, to targetCurrency: Currency, with rates: [String : Float]) -> String {

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
    func displayDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "FR-fr")

        return dateFormatter.string(from: date)
    }
}
