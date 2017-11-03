//
//  ModelRequestJSONEncoder.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/9/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

public protocol ModelRequestEncoderDelegate {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

public class ModelRequestJSONEncoder: ModelRequestEncoderDelegate {
    
    public let encoder: JSONEncoder
    
    public init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    public func encode<T>(_ value: T) throws -> Data where T : Encodable {
        return try encoder.encode(value)
    }
}

public enum URLEncoderError: Error {
    case unableToConvertToDictionary, unableToCreateQueryString
}

public class ModelRequestURLEncoder: ModelRequestEncoderDelegate {
    
    public let encoder: JSONEncoder
    
    public init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    public func encode<T>(_ value: T) throws -> Data where T : Encodable {
        let data = try encoder.encode(value)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
            throw URLEncoderError.unableToConvertToDictionary
        }
        var nonNullValuesDictionary: [String : Any] = [:]
        dictionary.forEach { key, value in
            if !(value is NSNull) {
                nonNullValuesDictionary[key] = value
            }
        }
        guard let queryStringData = nonNullValuesDictionary.queryParameters.data(using: .utf8) else {
            throw URLEncoderError.unableToCreateQueryString
        }
        return queryStringData
    }
}
