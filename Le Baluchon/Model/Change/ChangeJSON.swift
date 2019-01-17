//
//  Change.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

struct ChangeJSON: Decodable {

    var rates: [String : Float]
    private var date: String

    // convert the string in json into date
    var getDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-M-d"

        guard let dateFormatted = dateFormatter.date(from: date) else {
            return nil
        }

        return dateFormatted
    }
}
