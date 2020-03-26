//
//  PlacesProviderDataSourceMock.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 24/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation
@testable import Places

class PlacesProviderDataSourceMock {
    var locations: [Location]?
    var locationDetails: Location?
    var error: NSError?

    var getPlaceDetailsCalled = false
    var getPlacesCalled = false
    var getNextPlacesCalled = false
}

extension PlacesProviderDataSourceMock: PlacesProviderDataSource {
    func getPlaceDetails(placeId: String, completionHandler: @escaping (Result<Location, NSError>) -> Void) {
        getPlaceDetailsCalled = true

        if let location = locationDetails {
            completionHandler(.success(location))
        } else if let error = error {
            completionHandler(.failure(error))
        }
    }

    func getPlaces(location: String, radius: Int, type: LocationType?, completionHandler: @escaping (Result<[Location], NSError>) -> Void) {
        getPlacesCalled = true

        if let locations = locations {
            completionHandler(.success(locations))
        } else if let error = error {
            completionHandler(.failure(error))
        }
    }

    func getNextPlaces(completionHandler: @escaping (Result<[Location], NSError>) -> Void) {
        getNextPlacesCalled = true

        if let locations = locations {
            completionHandler(.success(locations))
        } else if let error = error {
            completionHandler(.failure(error))
        }
    }
}
