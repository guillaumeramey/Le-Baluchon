//
//  Cities.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 09/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

let paris = City(name: "Paris", id: 6455259, background: "paris", timeZone: "CET")
let newYork = City(name: "New York", id: 5128581, background: "newYork", timeZone: "EST")
let chicago = City(name: "Chicago", id: 4887398, background: "chicago", timeZone: "CET")
let lasVegas = City(name: "Las Vegas", id: 5506956, background: "lasVegas", timeZone: "PST")
let losAngeles = City(name: "Los Angeles", id: 5368361, background: "losAngeles", timeZone: "PST")
let seattle = City(name: "Seattle", id: 5809844, background: "seattle", timeZone: "CET")
let washington = City(name: "Washington", id: 4366164, background: "washington", timeZone: "CET")

let allCities = [chicago, lasVegas, losAngeles, newYork, paris, seattle, washington]

// Store the selected cities in the user defaults by using an array of id
private struct Keys {
    static let selectedCities = "selectedCities"
}

var selectedCities: [City] {
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

var availableCities: [City] {
    return allCities.filter { !selectedCities.contains($0) }
}
