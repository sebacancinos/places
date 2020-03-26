//
//  TestPlaceDetailsPresenter.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 25/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import XCTest
@testable import Places

class TestPlaceDetailsPresenter: XCTestCase {
    var presenter: PlaceDetailPresenter!
    var view: PlaceDetailViewControllerMock!
    var interactor: PlaceDetailInteractorMock!
    var router: PlaceDetailRouterMock!

    override func setUp() {
        super.setUp()

        view = PlaceDetailViewControllerMock()
        interactor = PlaceDetailInteractorMock()
        router = PlaceDetailRouterMock()

        presenter = PlaceDetailPresenter(interface: view,
                                         interactor: interactor,
                                         router: router)
    }

    override func tearDown() {
    }

    func testReady() {
        presenter.ready()

        XCTAssert(interactor.loadLocationCalled)
    }
}
