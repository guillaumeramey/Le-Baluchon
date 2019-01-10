import Foundation

class WeatherService {
    // singleton pattern
    static var shared = WeatherService()
    private init() {}

    let apiUrl = "http://api.openweathermap.org/data/2.5/group?"
    let apiKey = valueForAPIKey("openweather")

    private var task: URLSessionDataTask!

    private var weatherSession = URLSession.init(configuration: .default)

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }

    // API request
    func getWeather(for cities: [City], callback: @escaping (Bool, WeatherJSON?) -> Void) {

        let requestUrl = apiUrl
            + "id=" + cities.map {"\($0.id)"}.joined(separator: ",")
            + "&units=metric"
            + "&appid=" + apiKey

        let request = URLRequest(url: URL(string: requestUrl)!)

        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                do {
                    let weatherJSON = try JSONDecoder().decode(WeatherJSON.self, from: data)
                    callback(true, weatherJSON)
                } catch {
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }
}
