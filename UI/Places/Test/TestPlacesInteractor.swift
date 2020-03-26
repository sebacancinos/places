//
//  TestPlacesInteractor.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 26/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Places

class TestPlacesInteractor: XCTestCase {
    var presenter: PlacesPresenterMock!
    var interactor: PlacesInteractor!
    var datasource: PlacesProviderDataSourceMock!
    var location: Location!
    var image: UIImage!

    override func setUp() {
        super.setUp()

        datasource = PlacesProviderDataSourceMock()
        presenter = PlacesPresenterMock()
        interactor = PlacesInteractor()

        interactor.dataSource = datasource
        interactor.presenter = presenter

        location = Location(icon: "icon", identifier: "1234", name: "Location Test",
                            photos: [LocationPhoto(height: 10, width: 10, reference: "ref1111"),
                                    LocationPhoto(height: 10, width: 10, reference: "ref2222")],
                            placeId: "1234", rating: 2.4, types: ["type1", "type2"], userRatings: 2.4,
                            vicinity: "vicinity1", openHours: OpeningHours(openNow: true), reviews: nil)

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadLocationsByType() {
        let currentlocation = CLLocationCoordinate2D(latitude: 12.432, longitude: 12.345)

        datasource.locations = [location]
        interactor.currentLocation = currentlocation
        interactor.loadLocations(by: .liquorStore)

        XCTAssert(datasource.getPlacesCalled)
        XCTAssertEqual(presenter.locationsPresented?.count, 1)
        XCTAssertEqual(interactor.selectedType, .liquorStore)
    }

    func testLoadLocationsWithNoGeoLocation() {
        interactor.currentLocation = nil
        interactor.loadLocations(by: .liquorStore)

        XCTAssertFalse(datasource.getPlacesCalled)
    }

    func testLoadLocationsFail() {
        let currentlocation = CLLocationCoordinate2D(latitude: 12.432, longitude: 12.345)
        let error = NSError(domain: "TESTING", code: 1, userInfo: nil)

        datasource.error = error
        interactor.currentLocation = currentlocation
        interactor.loadLocations(by: .liquorStore)

        XCTAssert(datasource.getPlacesCalled)
        XCTAssertEqual(interactor.selectedType, .liquorStore)
        XCTAssertNotNil(presenter.errorPresented)
    }

    func testLoadNext() {
        datasource.locations = [location]
        interactor.places = [location]

        interactor.loadNextLocations()

        XCTAssert(datasource.getNextPlacesCalled)
        XCTAssertEqual(presenter.locationsPresented?.count, 2)
    }

    func testLoadDetails() {
        datasource.locationDetails = location
        interactor.loadDetails(for: location)

        XCTAssert(datasource.getPlaceDetailsCalled)
        XCTAssertEqual(presenter.locationDetailsToPresent?.placeId, "1234")
    }
}
