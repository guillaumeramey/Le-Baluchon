//
//  Constants.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

struct Constants {

    // Wrapper for obtaining keys from keys.plist
    static func valueForAPIKey(_ keyname: String) -> String {
        // Get the file path for keys.plist
        let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")

        // Put the keys in a dictionary
        let plist = NSDictionary(contentsOfFile: filePath!)

        // Pull the value for the key
        let value: String = plist?.object(forKey: keyname) as! String

        return value
    }
    
    // MARK: - WEATHER
    static let paris = City(name: "Paris", id: 6455259, image: "paris", timeZone: "CET")
    static let newYork = City(name: "New York", id: 5128581, image: "newYork", timeZone: "EST")
    static let chicago = City(name: "Chicago", id: 4887398, image: "chicago", timeZone: "CST")
    static let lasVegas = City(name: "Las Vegas", id: 5506956, image: "lasVegas", timeZone: "PST")
    static let losAngeles = City(name: "Los Angeles", id: 5368361, image: "losAngeles", timeZone: "PST")
    static let seattle = City(name: "Seattle", id: 5809844, image: "seattle", timeZone: "PST")
    static let washington = City(name: "Washington", id: 4366164, image: "washington", timeZone: "EST")

    static let allCities = [chicago, lasVegas, losAngeles, newYork, paris, seattle, washington]
}
