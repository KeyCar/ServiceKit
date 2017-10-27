//
//  Service.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/6/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

public typealias ModelResponse<T> = (success: (T) -> Void, failure: (Error) -> Void, completion: () -> Void)
public typealias EmptyResponse = (success: () -> Void, failure: (Error) -> Void, completion: () -> Void)

public enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

public class Service {
    
    public static let shared = Service()
    
    public var configuration: ServiceConfiguration?
    public var responseHandlerDelegate: ModelResponseHandlerDelegate?
    public var requestEncoderDelegate: ModelRequestEncoderDelegate?
    
    private init() { }
    
    public func request<T>(for type: T.Type, with identifier: String? = nil, parameters: [URLQueryItem]? = nil, method: HTTPMethod = .get) -> URLRequest where T : ServiceModel {
        let paths = [type.serviceClassName, identifier].flatMap { $0 }
        return request(with: paths, parameters: parameters, method: method)
    }
    
    public func request<T, U>(for type: T.Type, with identifier: String, relatedType: U.Type, relatedTypeIdentifier: String? = nil, parameters: [URLQueryItem]? = nil, method: HTTPMethod = .get) -> URLRequest where T : ServiceModel, U : ServiceModel {
        let paths = [type.serviceClassName, identifier, relatedType.serviceClassName, relatedTypeIdentifier].flatMap { $0 }
        return request(with: paths, parameters: parameters, method: method)
    }
    
    private func request(with paths: [String], parameters: [URLQueryItem]? = nil, method: HTTPMethod) -> URLRequest {
        guard let configuration = configuration else {
            fatalError("unable to create query, service configuration not set")
        }
        
        var url = configuration.url
        paths.forEach { url.appendPathComponent($0) }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters
        
        guard let componentsURL = components?.url else { fatalError("unable to create url") }
        
        var request = URLRequest(url: componentsURL)
        request.httpMethod = method.rawValue
        
        configuration.headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
}
