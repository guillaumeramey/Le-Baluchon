//
//  Translation.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

struct TranslationJSON: Decodable {
    private var data: JsonData

    struct JsonData: Decodable {
        var translations: [Translations]
    }

    struct Translations: Decodable {
        var translatedText: String
    }

    // easy access
    var translatedText: String {
        return data.translations[0].translatedText
    }
}

