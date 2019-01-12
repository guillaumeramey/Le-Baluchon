//
//  Translation.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

struct Translation: Decodable {
    private var data: JsonData

    var translatedText: String {
        return data.translations[0].translatedText
    }
}

struct JsonData: Decodable {
    var translations: [Translations]
}

struct Translations: Decodable {
    var translatedText: String
}
