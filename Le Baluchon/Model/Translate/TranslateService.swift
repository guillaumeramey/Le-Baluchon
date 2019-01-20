//
//  TranslateService.swift
//  Le Baluchon
//
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

import Foundation

class TranslateService {
    // singleton pattern
    static var shared = TranslateService()
    private init() {}

    private let apiUrl = "https://translation.googleapis.com/language/translate/v2"
    private let apiKey = valueForAPIKey("google")

    private var task: URLSessionDataTask!

    private var translateSession = URLSession.init(configuration: .default)

    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

    // API request
    func translate(_ textToTranslate: String, from sourceLanguage: Language, to targetLanguage: Language, callback: @escaping (Bool, TranslationJSON?) -> Void) {

        let urlString = apiUrl
            + "?q=" + textToTranslate
            + "&key=" + apiKey
            + "&source=" + sourceLanguage.rawValue
            + "&target=" + targetLanguage.rawValue
            + "&format=text"

        // removes forbidden characters
        guard let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: encodeString) else {
            callback(false, nil)
            return
        }

        let request = URLRequest(url: url)

        task?.cancel()
        task = translateSession.dataTask(with: request) { (data, response, error) in
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
                    let translationJSON = try JSONDecoder().decode(TranslationJSON.self, from: data)
                    callback(true, translationJSON)
                } catch {
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }
}
