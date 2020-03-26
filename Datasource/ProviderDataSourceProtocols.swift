//
//  ProviderDataSourceProtocols.swift
//  Places
//
//  Created by Sebastian Cancinos on 23/02/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation
import UIKit

protocol PlacesProviderDataSource {
    func getPlaces(location: String, radius: Int, type: LocationType?, completionHandler: @escaping (Result<[Location], NSError>) -> Void)
    func getNextPlaces(completionHandler: @escaping (Result<[Location], NSError>) -> Void)
    func getPlaceDetails(placeId: String, completionHandler: @escaping (Result<Location, NSError>) -> Void)
}

protocol ImageProviderDataSource {
    func getImage(with reference: String, completion: @escaping (Result<UIImage, NSError>) -> Void)
}
