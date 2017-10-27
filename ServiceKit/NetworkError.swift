//
//  NetworkError.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/18/17.
//  Copyright © 2017 KeyCar. All rights reserved.
//

import Foundation

public struct NetworkError: LocalizedError {
    public let statusCode: Int
    public var errorDescription: String? {
        return HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
    public var data: Data?
}

