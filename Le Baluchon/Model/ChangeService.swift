import Foundation

class ChangeService {

    private let changeUrl = URL(string: "http://data.fixer.io/api/latest?access_key=a379e695a1f14ed79ab8f9bd2ff1a688&symbols=USD")!
    private var task: URLSessionDataTask!

    let session = URLSession.init(configuration: .default)

    func getRates(callback: @escaping (Bool, Change?) -> Void) {
        let request = URLRequest(url: changeUrl)

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
                    let change = try JSONDecoder().decode(Change.self, from: data)
                    callback(true, change)
                } catch {
                    callback(false, nil)
                }
            }
        }
        task?.resume()
    }
}