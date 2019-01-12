//
//  CitiesTestCase.swift
//  Le BaluchonTests
//
//  Created by Guillaume Ramey on 11/01/2019.
//  Copyright © 2019 Guillaume Ramey. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class CitiesTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.set(nil, forKey: "selectedCities")
    }

    func testGivenListOfCitiesWhenAddingCityToSelectedCitiesThenCityIsRemovedFromAvailableCities() {
        // given
        XCTAssertEqual(allCities.count, selectedCities.count + availableCities.count)
        XCTAssertTrue(availableCities.contains(chicago))
        XCTAssertFalse(selectedCities.contains(chicago))

        // when
        selectedCities.append(chicago)

        // then
        XCTAssertEqual(allCities.count, selectedCities.count + availableCities.count)
        XCTAssertFalse(availableCities.contains(chicago))
        XCTAssertTrue(selectedCities.contains(chicago))
    }
}
