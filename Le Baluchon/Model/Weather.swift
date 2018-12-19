import Foundation

struct Weather: Decodable {
    let query: Query

    var code: String {
        return query.results.channel.item.condition.code
    }

    var temperature: String {
        return query.results.channel.item.condition.temp + "°"
    }

    // Formats the date
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "FR-fr")

        guard let date = formatDate() else {
            return "Impossible de formater la date"
        }

        return dateFormatter.string(from: date)
    }

    func formatDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM y hh:mm a"

        var dateString = query.results.channel.item.condition.date
        dateString.removeLast(4)

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        return date
    }

    func isDaylight() -> Bool {
        guard let date = formatDate() else {
            return true
        }

        let hour = Calendar.current.component(.hour, from: date)

        if hour >= 7 && hour <= 21 {
            return true
        }

        return false
    }

    func getImage(forCode code: String) -> Data? {
        var urlString = "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/"
        urlString += code
        urlString += isDaylight() ? "d" : "n"
        urlString += ".png"
        do {
            return try Data(contentsOf: URL(string: urlString)!)
        } catch {
            return nil
        }
    }
}

struct Query: Decodable {
    let results: Results
}

struct Results: Decodable {
    let channel: Channel
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
}

