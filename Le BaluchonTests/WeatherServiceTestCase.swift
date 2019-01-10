import XCTest
@testable import Le_Baluchon

class WeatherServiceTestCase: XCTestCase {

    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue weather.")
        weatherService.getWeather(for: [paris], callback: { (success, weather) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)

            let temperature = "2"
            let date = "(4 janvier 2019 à 04:55)"
            let conditionImage = UIImage(named: "wi_fog")

            paris.temperature = "\(Int((weather?.list[0].main.temp.rounded())!))"
            paris.date = weather?.list[0].date
            paris.conditionImage = UIImage(named: weather!.list[0].weather[0].conditionImage)

            XCTAssertEqual(temperature, paris.temperature)
            XCTAssertEqual(date, paris.displayDate)
            XCTAssertEqual(conditionImage, paris.conditionImage)

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil,response: nil,error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue weather.")
        weatherService.getWeather(for: [paris], callback: { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil,response: nil,error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue weather.")
        weatherService.getWeather(for: [paris], callback: { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue weather.")
        weatherService.getWeather(for: [paris], callback: { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue weather.")
        weatherService.getWeather(for: [paris], callback: { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
