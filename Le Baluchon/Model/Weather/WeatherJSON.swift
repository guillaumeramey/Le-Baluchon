import Foundation

struct WeatherJSON: Decodable {
    var cnt: Int
    var list: [List]

    struct List: Decodable {
//        var coord: Coord
//        var sys: Sys
//        var wind: Wind
//        var clouds: Clouds
        var weather: [Weather]
        var main: Main
//        var visibility: Int
        var dt: Int
        var id: Int
        var name: String
        var date: Date {
            return NSDate(timeIntervalSince1970: TimeInterval(dt)) as Date
        }
    }
    struct Main: Decodable {
        var temp: Double
//        var pressure: Double
//        var humidity: Double
//        var temp_min: Double
//        var temp_max: Double
    }
    struct Weather: Decodable {
        var id: Int
//        var main: String
//        var description: String
//        var icon: String
        var weatherIcon: String {
            switch (id) {
            case 0...300:
                return "wi_tstorm1"
            case 301...500:
                return "wi_light_rain"
            case 501...600:
                return "wi_shower3"
            case 601...700:
                return "wi_snow4"
            case 701...771:
                return "wi_fog"
            case 772...799, 900...903, 905...1000:
                return "wi_tstorm3"
            case 800, 904:
                return "wi_sunny"
            case 801...804:
                return "wi_cloudy2"
            case 903:
                return "wi_snow5"
            default:
                return "wi_dunno"
            }
        }
    }
//    struct Coord : Decodable {
//        var lon: Double
//        var lat: Double
//    }
//    struct Sys: Decodable {
//        var type: Int
//        var id: Int
//        var message: Double
//        var country: String
//        var sunrise: Int
//        var sunset: Int
//    }
//    struct Wind: Decodable {
//        var speed: Double
//        var deg: Double
//    }
//    struct Clouds: Decodable {
//        var all: Double
//    }
}
