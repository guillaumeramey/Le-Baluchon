//
//  Change.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

struct ChangeJSON: Decodable {

    enum CodingKeys: String, CodingKey {
        case rates = "rates"
        case dateString = "date"
    }

    var rates: [String : Float]
    private var dateString: String

    // convert the string in json into date
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-M-d"

        guard let dateFormatted = dateFormatter.date(from: dateString) else {
            fatalError()
        }

        return dateFormatted
    }
}
