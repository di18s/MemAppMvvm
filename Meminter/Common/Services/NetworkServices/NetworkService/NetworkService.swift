//
//  NetworkManager.swift
//  SimpleDrawing
//
//  Created by Дмитрий on 09/09/2019.
//  Copyright © 2019 Дмитрий. All rights reserved.
//

import Foundation

protocol NetworkServiceInput: class {
    func get<T: Codable>(_ method: APIMethod, completion: @escaping (T?, String?) -> Void)
    func post(imageData: Data?, by method: APIMethod, completion: @escaping (String?) -> Void)
    func post(by method: APIMethod, completion: @escaping (String?) -> Void)
}

final class NetworkService: NetworkServiceInput {
    private let urlSession: URLSession
    private let urlRequestBilder: URLRequestBuilderType
        
    init(urlSession: URLSession = .init(configuration: .default), urlRequestBilder: URLRequestBuilderType) {
        self.urlSession = urlSession
        self.urlRequestBilder = urlRequestBilder
    }
    
    func get<T: Codable>(_ method: APIMethod, completion: @escaping (T?, String?) -> Void) {
        self.urlSession.dataTask(with: method.url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print(response.url as Any, " - ", response.statusCode)
            }
            if let error = error {
                completion(nil, error.localizedDescription)
            } else if let data = data, let value = try? JSONDecoder().decode(T.self, from: data) {
                completion(value, nil)
            }
        }.resume()
    }
    
    func post(imageData: Data?, by method: APIMethod, completion: @escaping (String?) -> Void) {
        guard let request = self.urlRequestBilder.makeURLRequestWithMultipart(data: imageData, url: method.url) else {
            completion("Error create request")
            return
        }
        self.urlSession.uploadTask(with: request, from: request.httpBody) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.url as Any, " - ", response.statusCode)
            }
            completion(error?.localizedDescription)
        }.resume()
    }
    
    func post(by method: APIMethod, completion: @escaping (String?) -> Void) {
        guard let request = self.urlRequestBilder.makeURLRequest(url: method.url, httpMethod: .post, contentType: .applicationJson) else {
            completion("Error create request")
            return
        }
        self.urlSession.dataTask(with: request) { (d, r, error) in
            if let response = r as? HTTPURLResponse {
                print(response.url as Any, " - ", response.statusCode)
            }
            completion(error?.localizedDescription)
        }.resume()
    }
}
