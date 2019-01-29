//
//  ChangeService.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

class ChangeService {
    // singleton pattern
    static var shared = ChangeService()
    private init() {}

    private let apiUrl = "http://data.fixer.io/api/latest"
    private let apiKey = valueForAPIKey("fixer")

    private var task: URLSessionDataTask!
    private var changeSession = URLSession.init(configuration: .default)

    init(changeSession: URLSession) {
        self.changeSession = changeSession
    }

    // API request
    func getRates(callback: @escaping (Bool, ChangeJSON?) -> Void) {

        let urlString = apiUrl
            + "?access_key=" + apiKey
            + "&symbols=USD"

        guard let url = URL(string: urlString) else {
            callback(false, nil)
            return
        }

        task?.cancel()
        task = changeSession.dataTask(with: url) { (data, response, error) in
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
                    let change = try JSONDecoder().decode(ChangeJSON.self, from: data)
                    callback(true, change)
                } catch {
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }
}
