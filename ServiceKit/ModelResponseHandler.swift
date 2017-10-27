//
//  ModelResponseHandler.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/9/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

public protocol ModelResponseHandlerDelegate {
    func handleModelResponse<T>(data: Data?, urlResponse: URLResponse?, decoding: T.Type, error: Error?, response: ModelResponse<T>) where T : Codable
    func handleEmptyResponse(data: Data?, urlResponse: URLResponse?, error: Error?, response: EmptyResponse)
}

public class ModelResponseHandler: ModelResponseHandlerDelegate {
    
    public let decoder: JSONDecoder
    
    public var resultsKey: String?
    
    public init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    public func handleModelResponse<T>(data: Data?, urlResponse: URLResponse?, decoding: T.Type, error: Error?, response: ModelResponse<T>) where T : Codable {
        DispatchQueue.main.async {
            let result = self.resolveResponse(data: data, urlResponse: urlResponse, decoding: decoding, error: error)
            self.buildResponse(response: response, result: result)
        }
    }
    
    public func handleEmptyResponse(data: Data?, urlResponse: URLResponse?, error: Error?, response: EmptyResponse) {
        DispatchQueue.main.async {
            if let error = error {
                response.failure(error)
            } else {
                response.success()
            }
            response.completion()
        }
    }
    
    private func buildResponse<T>(response: ModelResponse<T>, result: (parsed: T?, error: Error?)) {
        if let parsed = result.parsed {
            response.success(parsed)
        } else if let error = result.error {
            response.failure(error)
        }
        response.completion()
    }
    
    private func resolveResponse<T>(data: Data?, urlResponse: URLResponse?, decoding type: T.Type, error: Error?) -> (parsed: T?, error: Error?) where T : Codable {
        var result: T? = nil
        var error: Error? = error
        if let urlResponse = urlResponse as? HTTPURLResponse {
            if (200..<300).contains(urlResponse.statusCode), let data = data {
                do {
                    if let resultsKey = resultsKey,
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                        let wrappedData = json[resultsKey] {
                        let newData = try JSONSerialization.data(withJSONObject: wrappedData, options: [])
                        result = try decoder.decode(type, from: newData)
                    } else {
                        result = try decoder.decode(type, from: data)
                    }
                } catch let e {
                    error = e
                }
            } else {
                error = NetworkError(statusCode: urlResponse.statusCode, data: data)
            }
        }
        return (result, error)
    }
}

