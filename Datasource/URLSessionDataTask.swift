//
//  URLSessionDataTask.swift
//  Places
//
//  Created by Sebastian Cancinos on 22/03/2020.
//  Copyright © 2020 sebacancinos. All rights reserved.
//

import Foundation

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url,
                         completionHandler: completionHandler)
            as URLSessionDataTask) as URLSessionDataTaskProtocol
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request,
                         completionHandler: completionHandler) as URLSessionDataTask)
            as URLSessionDataTaskProtocol
    }
}
