//
//  City.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 31/12/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

import UIKit

let paris = City(name: "PARIS", woeid: "615702", background: "paris", selected: true)
let newYork = City(name: "NEW-YORK", woeid: "2459115", background: "newyork", selected: true)
let bangkok = City(name: "BANGKOK", woeid: "1225448", background: "bangkok", selected: true)
let tokyo = City(name: "TOKYO", woeid: "1118370", background: "tokyo", selected: true)
let dubai = City(name: "DUBAI", woeid: "1940345", background: "dubai", selected: true)
let rome = City(name: "ROME", woeid: "721943", background: "rome", selected: true)
let istanbul = City(name: "ISTANBUL", woeid: "2347289", background: "istanbul", selected: true)

let cities = [paris, newYork, bangkok, tokyo, dubai, rome, istanbul]

class City {
    var name: String
    var caption: String
    var woeid: String
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

    init(name: String, woeid: String, background: String, selected: Bool) {
        self.name = name
        self.woeid = woeid
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
