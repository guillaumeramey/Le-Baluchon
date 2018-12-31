import Foundation

struct Weather: Decodable {
    let query: Query
}

struct Query: Decodable {
    let results: Results
}

struct Results: Decodable {
    let channel: [Channel]
}

struct Channel: Decodable {
    let item: Item
}

struct Item: Decodable {
    let condition: Condition
}

struct Condition: Decodable {
    let code: String
    let temp: String
    let text: String
    let date: String


    // convert string to date
    var dateFormatted: Date? {
        var dateString = date
        dateString.removeLast(4)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM y hh:mm a"

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        return date
    }
}

