//
//  City.swift
//  Le Baluchon
//
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

// US Cities backgrounds designes by Rwdd_studios - Freepik.com
// Paris background designed by Freepik.com

import UIKit

class City: Equatable {
    var name: String
    var caption: String
    var id: Int
    var image: UIImage
    var date: Date? = nil
    var timeZone: TimeZone
    var temperature = ""
    var conditionImage: UIImage? = nil

    init(name: String, id: Int, image: String, timeZone: String) {
        self.name = name
        self.id = id
        self.image = UIImage(named: image)!
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
