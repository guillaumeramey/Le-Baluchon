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

class City: Equatable {

    var name: String
    var caption: String
    var id: Int
    var background: UIImage?
    var date: Date? = nil
    var timeZone: TimeZone
    var temperature = ""
    var conditionImage: UIImage? = nil

    init(name: String, id: Int, background: String, timeZone: String) {
        self.name = name
        self.id = id
        self.background = UIImage(named: "city_bg_" + background) ?? nil
        self.caption = name.uppercased()
        self.timeZone = TimeZone(identifier: timeZone) ?? .current
    }

    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id ? true : false
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
