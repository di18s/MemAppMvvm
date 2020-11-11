//
//  URLRequestBuilder.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ContentType {
    case multipart
    case applicationJson
}

protocol URLRequestBuilderType: class {
    func makeURLRequest(url: URL, httpMethod: HTTPMethod, contentType: ContentType) -> URLRequest?
    func makeURLRequestWithMultipart(data: Data?, url: URL) -> URLRequest?
}

final class URLRequestBuilder: URLRequestBuilderType {
    private let boundary = UUID().uuidString
    
    func makeURLRequest(url: URL, httpMethod: HTTPMethod = .post, contentType: ContentType) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        switch contentType {
        case .applicationJson:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .multipart:
            request.setValue("multipart/form-data; boundary=\(self.boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func makeMultipartdata(with data: Data?) -> Data? {
        guard let data = data else { return nil }
        
        let filename = "image.jpeg"
        var dataContainer = Data()
        
        dataContainer.append("\r\n--\(self.boundary)\r\n".data(using: .utf8)!)
        dataContainer.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        dataContainer.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        dataContainer.append(data)
        dataContainer.append("\r\n--\(self.boundary)--\r\n".data(using: .utf8)!)
        
        return dataContainer
    }
    
    func makeURLRequestWithMultipart(data: Data?, url: URL) -> URLRequest? {
        guard var request = self.makeURLRequest(url: url, httpMethod: .post, contentType: .multipart) else { return nil }
        request.httpBody = self.makeMultipartdata(with: data)
        return request
    }
}
