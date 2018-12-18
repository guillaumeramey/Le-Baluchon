//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Guillaume Ramey on 18/12/2018.
//  Copyright © 2018 Guillaume Ramey. All rights reserved.
//

import Foundation

class WeatherService {

    enum City: String {
        case paris = "615702"
        case newyork = "2459115"
    }

    private let queryUrl = URL(string: "https://query.yahooapis.com/v1/public/yql?")!

    private var task: URLSessionDataTask!

    let session = URLSession.init(configuration: .default)

    func getWeather(for city: City, callback: @escaping (Bool, Weather?) -> Void) {

        //let request = URLRequest(url: endPoint)
        let request = createQuoteRequest(for: city)

        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
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
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    callback(true, weather)
                } catch {
                    callback(false, nil)
                }

            }
        }
        task?.resume()
    }

    private func createQuoteRequest(for city: City) -> URLRequest {
        var request = URLRequest(url: queryUrl)
        request.httpMethod = "POST"

        var body = "q=select item.condition from weather.forecast where woeid = " + city.rawValue + " and u='c'"
        body += "&format=json&env=store://datatables.org/alltableswithkeys"
        request.httpBody = body.data(using: .utf8)
        return request
    }
}
