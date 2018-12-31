//
//  City.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 31/12/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

import UIKit

let paris = City(name: "PARIS", woeid: "615702")
let newYork = City(name: "NEW-YORK", woeid: "2459115")

let cities = [paris, newYork]

class City {
    var name: String
    var woeid: String
    var date: Date?
    var code = ""
    var temperature = "?"

    init(name: String, woeid: String) {
        self.name = name
        self.woeid = woeid
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

    //gets an image describing the weather depending of the hour
    var weatherImage: UIImage? {
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

    // returns true if it's daytime in the city
    var isDaytime: Bool {
        guard let date = date else {
            return true
        }

        let hour = Calendar.current.component(.hour, from: date)

        return hour >= 7 && hour <= 21 ? true : false
    }
}
