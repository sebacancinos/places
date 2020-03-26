//
//  ImageProviderDataSourceMock.swift
//  PlacesTests
//
//  Created by Sebastian Cancinos on 24/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation
import UIKit
@testable import Places

class ImageProviderDataSourceMock {
    var image: UIImage?
    var error: NSError?

    var imageReference: String?
}

extension ImageProviderDataSourceMock: ImageProviderDataSource {
    func getImage(with reference: String, completion: @escaping (Result<UIImage, NSError>) -> Void) {
        imageReference = reference

        if let image = image {
            completion(.success(image))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}
