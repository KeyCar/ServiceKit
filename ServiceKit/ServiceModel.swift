//
//  ServiceModel.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/6/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

public protocol ServiceModel: Codable {
    static var serviceClassName: String { get }
    static var identifierKeyPath: AnyKeyPath? { get }
}

extension ServiceModel {
    
    public static var identifierKeyPath: AnyKeyPath? {
        return nil
    }
    
    public static var query: Query<Self> {
        return Query<Self>()
    }
    
    private var session: URLSession {
        return URLSession(configuration: .default)
    }
    
    public func deleteInBackground(response: EmptyResponse) {
        guard let identifier = serviceModelIdentifier(forValue: self) else {
            fatalError("object without identifer key path")
        }
        let service = Service.shared
        let request = service.request(for: Self.self, with: identifier, method: .delete)
        session.dataTask(with: request) { (data, urlResponse, error) in
            service.responseHandlerDelegate?.handleEmptyResponse(data: data, urlResponse: urlResponse, error: error, response: response)
        }.resume()
    }
    
    public func saveInBackground(response: ModelResponse<Self>) {
        let identifier = serviceModelIdentifier(forValue: self)
        let service = Service.shared
        let method: HTTPMethod = identifier != nil ? .put : .post
        var request = service.request(for: Self.self, with: identifier, method: method)
        do {
            request.httpBody = try service.requestEncoderDelegate?.encode(self)
            session.dataTask(with: request) { (data, urlResponse, error) in
                service.responseHandlerDelegate?.handleModelResponse(data: data, urlResponse: urlResponse, decoding: Self.self, error: error, response: response)
            }.resume()
        } catch {
            response.failure(error)
        }
    }
    
    public func saveRelatedValueInBackground<T>(relatedValue: T, response: ModelResponse<T>) where T : ServiceModel {
        guard let identifier = serviceModelIdentifier(forValue: self) else {
            fatalError("root object without identifer key path")
        }
        let service = Service.shared
        let relatedValueIdentifier = serviceModelIdentifier(forValue: relatedValue)
        let method: HTTPMethod = relatedValueIdentifier != nil ? .put : .post
        var request = service.request(for: Self.self, with: identifier, relatedType: T.self, relatedTypeIdentifier: relatedValueIdentifier, method: method)
        do {
            request.httpBody = try service.requestEncoderDelegate?.encode(relatedValue)
            session.dataTask(with: request) { (data, urlResponse, error) in
                service.responseHandlerDelegate?.handleModelResponse(data: data, urlResponse: urlResponse, decoding: T.self, error: error, response: response)
            }.resume()
        } catch {
            response.failure(error)
        }
    }
    
    private func serviceModelIdentifier<T>(forValue value: T) -> String? where T : ServiceModel {
        guard let keyPath = T.identifierKeyPath else { return nil }
        return value[keyPath: keyPath] as? String
    }
}

