import XCTest
@testable import Le_Baluchon

class TranslateServiceTestCase: XCTestCase {

    func testTranslateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.translateCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.translate("", from: .english, to: .french, callback: { (success, translation) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(translation)

            let translatedText = "Bonjour le monde"

            XCTAssertEqual(translatedText, translation!.translatedText)

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testTranslateShouldPostFailedCallbackIfError() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil,response: nil,error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.translate("", from: .english, to: .french, callback: { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testTranslateShouldPostFailedCallbackIfNoData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil,response: nil,error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.translate("", from: .english, to: .french, callback: { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testTranslateShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.translateCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.translate("", from: .english, to: .french, callback: { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testTranslateShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translateService.translate("", from: .english, to: .french, callback: { (success, translation) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

}
