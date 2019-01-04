//
//  City.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 31/12/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

import UIKit

let paris = City(name: "x", id: "6455259", background: "paris", selected: true)
let newYork = City(name: "x", id: "5128638", background: "newyork", selected: true)
let bangkok = City(name: "BANGKOK", id: "xxx", background: "bangkok", selected: false)
let tokyo = City(name: "TOKYO", id: "xxx", background: "tokyo", selected: false)
let dubai = City(name: "DUBAI", id: "xxx", background: "dubai", selected: false)
let rome = City(name: "ROME", id: "xxx", background: "rome", selected: false)
let istanbul = City(name: "ISTANBUL", id: "xxx", background: "istanbul", selected: false)

//let cities = [paris, newYork, bangkok, tokyo, dubai, rome, istanbul]
let availableCities = [paris, newYork]

class City {
    var name: String = ""
    var caption: String
    var id: String
    var background: UIImage?
    var date: Date? = nil
    var temperature = ""
    var conditionCode: String? = nil
    var conditionImage: UIImage? {
        if let code = conditionCode {
            var urlString = "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/"
            urlString += code
            urlString += isDaytime ? "d" : "n"
            urlString += ".png"

            do {
                let data = try Data(contentsOf: URL(string: urlString)!)
                return UIImage(data: data)
            } catch {
                return nil
            }
        }
        return nil
    }
    var selected: Bool

    init(name: String, id: String, background: String, selected: Bool) {
        self.name = name
        self.id = id
        self.background = UIImage(named: background) ?? nil
        self.caption = name + " (Mise à jour...)"
        self.selected = selected
    }

    // Formats the date for display
    var displayDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "FR-fr")

        guard let date = date else {
            return "Impossible de formater la date"
        }

        return "(le " + dateFormatter.string(from: date) + ")"
    }

    // returns true if it's daytime in the city
    private var isDaytime: Bool {
        guard let date = date else {
            return true
        }

        let hour = Calendar.current.component(.hour, from: date)

        return hour >= 7 && hour <= 21 ? true : false
    }
}
