import Foundation

class FakeResponseData {
    // MARK: - Data
    static var translateCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var changeCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Change", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let incorrectData = "error".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://www.google.com/")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://www.google.com/")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    // MARK: - Error
    class GenericError: Error {}
    static let error = GenericError()
}
