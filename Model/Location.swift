//
//  Location.swift
//  Places
//
//  Created by Sebastian Cancinos on 22/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation
import CoreLocation

struct GoogleResponse<T: Decodable>: Decodable {
    let token: String?
    let results: [T]

    private enum CodingKeys: String, CodingKey {
        case token = "next_page_token"
        case results
    }
}

struct GoogleSingleResponse<T: Decodable>: Decodable {
    let result: T
}

struct Location: Decodable {
    let icon: String
    let identifier: String
    let name: String
    let photos: [LocationPhoto]?
    let placeId: String
    let rating: Float?
    let types: [String]?
    let userRatings: Float?
    let vicinity: String
    let openHours: OpeningHours?
    let reviews: [UserReview]?

    private enum CodingKeys: String, CodingKey {
        case icon
        case identifier = "id"
        case name
        case photos
        case placeId = "place_id"
        case rating
        case types
        case userRatings = "user_ratings_total"
        case vicinity
        case openHours = "opening_hours"
        case reviews
    }
}

struct LocationPhoto: Decodable {
    let height: Int
    let width: Int
    let reference: String

    private enum CodingKeys: String, CodingKey {
        case height
        case width
        case reference = "photo_reference"
    }
}

struct OpeningHours: Decodable {
    let openNow: Bool

    private enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct UserReview: Decodable {
    let authorName: String
    let authorUrl: String
    let language: String
    let profilePhotoUrl: String
    let rating: Float
    let timeDescription: String
    let text: String
    let time: TimeInterval

    private enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorUrl = "author_url"
        case language
        case profilePhotoUrl = "profile_photo_url"
        case rating
        case timeDescription = "relative_time_description"
        case text
        case time
    }
}
