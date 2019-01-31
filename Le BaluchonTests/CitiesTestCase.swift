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
        XCTAssertEqual(Constants.allCities.count, Persist.selectedCities.count + Persist.availableCities.count)
        XCTAssertTrue(Persist.availableCities.contains(Constants.chicago))
        XCTAssertFalse(Persist.selectedCities.contains(Constants.chicago))

        // when
        Persist.selectedCities.append(Constants.chicago)

        // then
        XCTAssertEqual(Constants.allCities.count, Persist.selectedCities.count + Persist.availableCities.count)
        XCTAssertFalse(Persist.availableCities.contains(Constants.chicago))
        XCTAssertTrue(Persist.selectedCities.contains(Constants.chicago))
    }
}
