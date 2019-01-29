//
//  Persist.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

class Persist {

    private struct Keys {
        static let changeLastUpdate = "changeLastUpdate"
        static let changeLastRates = "changeLastRates"
        static let selectedCities = "selectedCities"
    }

    // MARK: - Change
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
    static var isUpdateNeeded: Bool {
        if let lastUpdate = Persist.lastUpdate {
            return !Calendar.current.isDate(Date(), equalTo: lastUpdate, toGranularity: .day)
        }
        return true
    }

    // MARK: - Weather
    static var selectedCities: [City] {
        get {
            guard let idArray = UserDefaults.standard.array(forKey: Keys.selectedCities) as? [Int] else {
                return [paris, newYork]
            }

            var cities = [City]()

            for id in idArray {
                for city in allCities {
                    if city.id == id {
                        cities.append(city)
                    }
                }
            }

            return cities
        }
        set {
            UserDefaults.standard.set(newValue.map { $0.id }, forKey: Keys.selectedCities)
        }
    }

    static var availableCities: [City] {
        return allCities.filter { !selectedCities.contains($0) }
    }
}
