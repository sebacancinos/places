//
//  URLSessionMock.swift
//  Places
//
//  Created by Sebastian Cancinos on 21/07/2019.
//  Copyright © 2019 sebacancinos. All rights reserved.
//

import Foundation
@testable import Places

class URLSessionMock {
    var lastURLCalled: String?
    var task: URLSessionDataTaskProtocol?
    var data: Data?
    var error: Error?
}

extension URLSessionMock: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURLCalled = request.url?.absoluteString

        if let data = data {
            completionHandler(data, nil, nil)
        } else if let error = error {
            completionHandler(nil, nil, error)
        }

        return task!
    }

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURLCalled = url.absoluteString

        if let data = data {
            completionHandler(data, nil, nil)
        } else if let error = error {
            completionHandler(nil, nil, error)
        }

        return task!
    }
}
