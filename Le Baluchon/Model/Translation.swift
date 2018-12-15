import Foundation

struct Translation: Codable {
    var data: JsonData
}

struct JsonData: Codable {
    var translations: [Translations]
}

struct Translations: Codable {
    var translatedText: String
}
