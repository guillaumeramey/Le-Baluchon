//
//  City.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 31/12/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//


// US Cities backgrounds designes by Rwdd_studios - Freepik.com
// Paris background designed by Freepik.com


import UIKit

let paris = City(name: "Paris", id: "6455259", background: "paris", timeZone: "CET", selected: true)
let newYork = City(name: "New York", id: "5128581", background: "newYork", timeZone: "EST", selected: true)
let chicago = City(name: "Chicago", id: "4887398", background: "chicago", timeZone: "CET", selected: false)
let lasVegas = City(name: "Las Vegas", id: "5506956", background: "lasVegas", timeZone: "PST", selected: false)
let losAngeles = City(name: "Los Angeles", id: "5368361", background: "losAngeles", timeZone: "PST", selected: false)
let seattle = City(name: "Seattle", id: "5809844", background: "seattle", timeZone: "CET", selected: false)
let washington = City(name: "Washington", id: "4366164", background: "washington", timeZone: "CET", selected: false)

let cities = [paris, newYork, chicago, lasVegas, losAngeles, seattle, washington]

class City {
    var name: String
    var caption: String
    var id: String
    var background: UIImage?
    var date: Date? = nil
    var timeZone: TimeZone
    var temperature = ""
    var conditionCode: String? = nil
    var conditionImage: UIImage? = nil
    var selected: Bool

    init(name: String, id: String, background: String, timeZone: String, selected: Bool) {
        self.name = name
        self.id = id
        self.background = UIImage(named: "city_bg_" + background) ?? nil
        self.caption = name + " (Mise à jour...)"
        self.selected = selected
        self.timeZone = TimeZone(identifier: timeZone) ?? .current
    }

    // Formats the date for display
    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "FR-fr")
        dateFormatter.timeZone = timeZone

        guard let date = date else {
            return "Impossible de formater la date"
        }

        return "(" + dateFormatter.string(from: date) + ")"
    }
}
