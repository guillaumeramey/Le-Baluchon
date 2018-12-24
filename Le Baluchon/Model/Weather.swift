import Foundation

struct Weather: Decodable {

    enum City: Int {
        case paris = 0, newyork
    }

    let query: Query

    func getTemperature(for city: City) -> String {
        return query.results.channel[city.rawValue].item.condition.temp + "°"
    }

    // Formats the date for display
    func getDate(for city: City) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "FR-fr")

        guard let date = formatDate(for: city) else {
            return "Impossible de formater la date"
        }

        return dateFormatter.string(from: date)
    }

    // gets an image describing the weather depending of the hour
    func getWeatherImage(for city: City) -> Data? {
        var urlString = "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/"
        urlString += query.results.channel[city.rawValue].item.condition.code
        urlString += isDaytime(in: city) ? "d" : "n"
        urlString += ".png"

        do {
            return try Data(contentsOf: URL(string: urlString)!)
        } catch {
            return nil
        }
    }

    // returns true if it's daytime in the city
    private func isDaytime(in city: City) -> Bool {
        guard let date = formatDate(for: city) else {
            return true
        }

        let hour = Calendar.current.component(.hour, from: date)

        if hour >= 7 && hour <= 21 {
            return true
        }

        return false
    }

    // converts the date in json file from string to date
    private func formatDate(for city: City) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM y hh:mm a"

        var dateString = query.results.channel[city.rawValue].item.condition.date
        dateString.removeLast(4)

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        return date
    }
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
}

