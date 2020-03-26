//
//  NetworkDatasource.swift
//  Places
//
//  Created by Sebastian Cancinos on 23/02/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation
import UIKit

class NetworkDataSource {
    // TODO: Move to info.plist
    private var backEndURL: URL?
    private var APIKEY: String!
    var urlSession: URLSessionProtocol?
    private static let imageCache = NSCache<NSString, AnyObject>()
    var placesToken: String?

    init() {
        if let url = Bundle.main.object(forInfoDictionaryKey: "BackendURL") as? String,
            let key = Bundle.main.object(forInfoDictionaryKey: "GoogleApiKey") as? String {
            setup(backend: URL(string: url), key: key)
        }
    }

    func setup(backend: URL?, key: String) {
        self.backEndURL = backend
        self.APIKEY = key
    }

    fileprivate func decode<T>(_ data: Data)-> Result<T, NSError>
        where T: Decodable {
        do {
            let decoder = JSONDecoder()
            let obj = try decoder.decode(T.self, from: data)

            return .success(obj)
        } catch let err as NSError {
            return .failure(err)
        }
    }

    fileprivate func getFromBackend<T>(query: String,
                                       params: [String: String]? = nil,
                                       completion: @escaping (Result<T, NSError>) -> Void)
        where T: Decodable {
        guard let backEnd = backEndURL,
            var urlComps = URLComponents(string: query) else { return }

        urlComps.queryItems = params?.map({ (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        })

        urlComps.queryItems?.append(URLQueryItem(name: "key", value: APIKEY))

        guard let url = urlComps.url(relativeTo: backEnd) else { return }
        var request = URLRequest(url: url)
        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        urlSession?.dataTask(with: request) { (data, _, error) in
            if let data = data {
                if let formatedData = data as? T {
                    completion(.success(formatedData))
                } else {
                    completion(self.decode(data))
                }
            } else if let error = error {
                completion(.failure(error as NSError))
            }
        }.resume()
    }
}

extension NetworkDataSource: ImageProviderDataSource {
    func getImage(with reference: String, completion: @escaping (Result<UIImage, NSError>) -> Void) {
        if let cachedImage = NetworkDataSource.imageCache.object(forKey: reference as NSString) as? UIImage {
            completion(.success(cachedImage))
        } else {
            downloadImage(with: reference, completion: completion)
        }
    }

    private func downloadImage(with reference: String, completion: @escaping (Result<UIImage, NSError>) -> Void) {
        let query = "photo"
        let params = ["photoreference": reference, "maxwidth": "450"]

        getFromBackend(query: query, params: params, completion: { (result: Result<Data, NSError>) -> Void in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    NetworkDataSource.imageCache.setObject(image, forKey: reference as NSString)

                    completion(.success(image))
                } else {
                    completion(.failure(NSError.init(domain: "PhotoEncodingError", code: 1, userInfo: nil)))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

extension NetworkDataSource: PlacesProviderDataSource {
    func getNextPlaces(completionHandler: @escaping (Result<[Location], NSError>) -> Void) {
        guard let token = placesToken else { return }

        let query = "nearbysearch/json"
        let params = ["pagetoken": token]

        getFromBackend(query: query, params: params) {[weak self] (result: Result<GoogleResponse<Location>, NSError>) -> Void in
            switch result {
            case .success(let response):
                self?.placesToken = response.token
                completionHandler(.success(response.results))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func getPlaces(location: String, radius: Int, type: LocationType?, completionHandler: @escaping (Result<[Location], NSError>) -> Void) {
        let query = "nearbysearch/json"
        var params = ["location": location, "radius": String(radius)]

        if let type = type {
            params["type"] = type.rawValue
        }

        getFromBackend(query: query, params: params) {[weak self] (result: Result<GoogleResponse<Location>, NSError>) -> Void in
            switch result {
            case .success(let response):
                self?.placesToken = response.token
                completionHandler(.success(response.results))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func getPlaceDetails(placeId: String, completionHandler: @escaping (Result<Location, NSError>) -> Void) {
        let query = "details/json"
        let params = ["place_id": placeId]

        getFromBackend(query: query, params: params) {(result: Result<GoogleSingleResponse<Location>, NSError>) -> Void in
            switch result {
            case .success(let response):
                completionHandler(.success(response.result))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }

    }

}
