//
//  LoginCredentials.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/19/17.
//  Copyright © 2017 KeyCar. All rights reserved.
//

import Foundation

public protocol LoginCredentials: ServiceModel {
    associatedtype Model : ServiceModel
}

extension LoginCredentials {
    
    public static var identifierKeyPath: AnyKeyPath? {
        return nil
    }
    
    public var session: URLSession {
        return .shared
    }
    
    public var service: Service {
        return .shared
    }
    
    public func login<Model>(response: ModelResponse<Model>) where Model : ServiceModel {
        var request = service.request(for: Self.self, method: .post)
        let encoder = service.requestEncoderDelegate
        do {
            request.httpBody = try encoder?.encode(self)
            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                self.service.responseHandlerDelegate?.handleModelResponse(data: data, urlResponse: urlResponse, decoding: Model.self, error: error, response: response)
            }
            task.resume()
        } catch {
            response.failure(error)
        }
    }
    
}
