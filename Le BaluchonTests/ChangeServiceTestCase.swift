import XCTest
@testable import Le_Baluchon

class ChangeServiceTestCase: XCTestCase {

    func testGetRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeResponseData.changeCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getRates { (success, change) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(change)

            let rates: [String : Float] = ["USD": 1.138349]
            let formattedDate = "23 décembre 2018"

            XCTAssertEqual(rates, change!.rates)
            XCTAssertEqual(formattedDate, change!.dateFormatted)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostFailedCallbackIfError() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: nil,response: nil,error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getRates { (success, change) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostFailedCallbackIfNoData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(data: nil,response: nil,error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getRates { (success, change) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeResponseData.changeCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getRates { (success, change) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRatesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let changeService = ChangeService(
            changeSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        changeService.getRates { (success, change) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(change)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

}
