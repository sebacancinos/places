//
//  URLSessionDataTaskMock.swift
//  Places
//
//  Created by Sebastian Cancinos on 21/07/2019.
//  Copyright © 2019 sebacancinos. All rights reserved.
//

import Foundation
@testable import Places

class URLSessionDataTaskMock {
    var resumeWasCalled = false
}

extension URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() {
        resumeWasCalled = true
    }
}
