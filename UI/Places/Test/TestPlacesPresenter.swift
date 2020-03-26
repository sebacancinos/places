//
//  TestPlacesPresenter.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 25/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import XCTest
@testable import Places

class TestPlacePresenter: XCTestCase {
    var presenter: PlacesPresenter!
    var view: PlacesViewControllerMock!
    var interactor: PlacesInteractorMock!
    var router: PlacesRouterMock!

    override func setUp() {
        super.setUp()

        view = PlacesViewControllerMock()
        interactor = PlacesInteractorMock()
        router = PlacesRouterMock()

        presenter = PlacesPresenter(interface: view,
                                         interactor: interactor,
                                         router: router)
    }

    override func tearDown() {
    }

    func testReady() {
        presenter.ready()

        XCTAssert(interactor.loadLocationsCalled)
    }

    func testRefresh() {
        presenter.refresh()

        XCTAssert(interactor.loadLocationsCalled)
    }

    func testInfiniteScroll() {
        presenter.infiniteScroll()

        XCTAssert(interactor.loadNextLocationsCalled)
    }

    func testSelectLocation() {
        let location = Location(icon: "icon", identifier: "1234", name: "Location Test",
                            photos: [LocationPhoto(height: 10, width: 10, reference: "ref1111"),
                                    LocationPhoto(height: 10, width: 10, reference: "ref2222")],
                            placeId: "1234", rating: 2.4, types: ["type1", "type2"], userRatings: 2.4,
                            vicinity: "vicinity1", openHours: OpeningHours(openNow: true), reviews: nil)

        presenter.select(location)

        XCTAssertEqual(interactor.locationForDetails?.identifier, "1234")
    }

    func testLocationsUpdate() {
        let location = Location(icon: "icon", identifier: "1234", name: "Location Test",
                            photos: [LocationPhoto(height: 10, width: 10, reference: "ref1111"),
                                    LocationPhoto(height: 10, width: 10, reference: "ref2222")],
                            placeId: "1234", rating: 2.4, types: ["type1", "type2"], userRatings: 2.4,
                            vicinity: "vicinity1", openHours: OpeningHours(openNow: true), reviews: nil)

        presenter.present(locations: [location, location, location])

        XCTAssertEqual(view.locationsUpdated?.count, 3)
    }
}
