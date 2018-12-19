import Foundation

struct Translation: Decodable {
    var data: JsonData

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
