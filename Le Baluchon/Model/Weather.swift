import Foundation

struct Weather: Decodable {
    let query: Query

    var code: String {
        return query.results.channel.item.condition.code
    }
    var temperature: String {
        return query.results.channel.item.condition.temp + "°"
    }
    var description: String {
        return query.results.channel.item.condition.text
    }

    func getImage(forCode code: String) -> Data? {
        do {
            let url = URL(string: "https://s.yimg.com/zz/combo?a/i/us/nws/weather/gr/" + code + "d.png")!
            return try Data(contentsOf: url)
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

