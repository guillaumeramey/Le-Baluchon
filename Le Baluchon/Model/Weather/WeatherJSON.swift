import Foundation

struct WeatherJSON: Decodable {
    var cnt: Int
    var list: [List]

    struct List: Decodable {
        var coord: Coord
        var sys: Sys
        var weather: [Weather]
        var main: Main
        var visibility: Int
        var wind: Wind
        var clouds: Clouds
        var dt: Int
        var id: Int
        var name: String

        var date: Date {
            return NSDate(timeIntervalSince1970: TimeInterval(dt)) as Date
        }

    }
    struct Coord : Decodable {
        var lon: Double
        var lat: Double
    }
    struct Sys: Decodable {
        var type: Int
        var id: Int
        var message: Double
        var country: String
        var sunrise: Int
        var sunset: Int
    }
    struct Weather: Decodable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    struct Main: Decodable {
        var temp: Double
        var pressure: Int
        var humidity: Int
        var temp_min: Double
        var temp_max: Double
    }
    struct Wind: Decodable {
        var speed: Double
        var deg: Int
    }
    struct Clouds: Decodable {
        var all: Int
    }
}
