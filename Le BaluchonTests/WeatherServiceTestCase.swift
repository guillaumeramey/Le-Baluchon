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
        weatherService.getWeather { (success, weather) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)

            let dateParis = "(le 23 décembre 2018 à 05:00)"
            let tempParis = "49"

            paris.date = weather?.query.results.channel[0].item.condition.dateFormatted
            paris.temperature = (weather?.query.results.channel[0].item.condition.temp)!

            XCTAssertEqual(dateParis, paris.displayDate)
            XCTAssertEqual(tempParis, paris.temperature)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil,response: nil,error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue weather.")
        weatherService.getWeather { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil,response: nil,error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue weather.")
        weatherService.getWeather { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }

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
        weatherService.getWeather { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }

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
        weatherService.getWeather { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
