import Foundation

class TranslateService {
    static var shared = TranslateService()
    private init() {}

    private let apiUrl = "https://translation.googleapis.com/language/translate/v2"
    private let apiKey = "AIzaSyA6LOP2joYT0W1QRhQy07ej13GAJiifSxE"
    private var task: URLSessionDataTask!

    private var translateSession = URLSession.init(configuration: .default)

    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

    func translate(_ query: String, _ sourceLanguage: Language, _ targetLanguage: Language, callback: @escaping (Bool, Translation?) -> Void) {

        let urlString = apiUrl
            + "?q=" + query
            + "&source=" + sourceLanguage.rawValue
            + "&target=" + targetLanguage.rawValue
            + "&key=" + apiKey

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
                    let translation = try JSONDecoder().decode(Translation.self, from: data)
                    callback(true, translation)
                } catch {
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }
}
