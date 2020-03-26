//
//  TestPlaceDetailsInteractor.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 25/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import XCTest
@testable import Places

class TestPlaceDetailsInteractor: XCTestCase {
    var presenter: PlaceDetailPresenterMock!
    var interactor: PlaceDetailInteractor!
    var datasource: ImageProviderDataSourceMock!
    var location: Location!
    var image: UIImage!

    override func setUp() {
        super.setUp()

        datasource = ImageProviderDataSourceMock()
        presenter = PlaceDetailPresenterMock()
        interactor = PlaceDetailInteractor()
        location = Location(icon: "icon", identifier: "1234", name: "Location Test",
                            photos: [LocationPhoto(height: 10, width: 10, reference: "ref1111"),
                                    LocationPhoto(height: 10, width: 10, reference: "ref2222")],
                            placeId: "1234", rating: 2.4, types: ["type1", "type2"], userRatings: 2.4,
                            vicinity: "vicinity1", openHours: OpeningHours(openNow: true), reviews: nil)

        interactor.dataSource = datasource
        interactor.presenter = presenter
        interactor.model = location

        image = UIImage.init(systemName: "house")
        datasource.image = image
    }

    func testLoadLocation() {
        interactor.loadLocation()

        XCTAssertEqual(presenter.placeShown?.name, "Location Test")
        XCTAssertEqual(presenter.lastPhotoAdded, image)
        XCTAssertEqual(datasource.imageReference, "ref2222")
        XCTAssertEqual(presenter.photoCount, 2)
    }
}
