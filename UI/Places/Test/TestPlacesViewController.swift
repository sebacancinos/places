//
//  TestPlacesViewController.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 26/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import XCTest
@testable import Places

class TestPlacesViewController: XCTestCase {
    var presenter: PlacesPresenterMock!
    var view: PlacesViewController!

    override func setUp() {
        super.setUp()

        view = PlacesViewController()
        presenter = PlacesPresenterMock()

        view.presenter = presenter
    }

    func selected(_ location: Location) {
        presenter?.select(location)
    }

    func infinteScroll() {
        presenter?.infiniteScroll()
    }

    func testFilter() {
        view.filter(by: .liquorStore)

        XCTAssertEqual(presenter.typeToFilter, .liquorStore)
    }

    func testSelect() {
        let location = Location(icon: "icon", identifier: "1234", name: "Location Test",
                            photos: [LocationPhoto(height: 10, width: 10, reference: "ref1111"),
                                    LocationPhoto(height: 10, width: 10, reference: "ref2222")],
                            placeId: "1234", rating: 2.4, types: ["type1", "type2"], userRatings: 2.4,
                            vicinity: "vicinity1", openHours: OpeningHours(openNow: true), reviews: nil)

        view.selected(location)

        XCTAssertEqual(presenter.locationSelected?.identifier, "1234")
    }

    func testInfiniteScroll() {
        view.infinteScroll()

        XCTAssert(presenter.infiniteScrollCalled)
    }
}
