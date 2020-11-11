//
//  URLExtension.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

extension URL {
    static let baseUrlString = "http://memapi.htc-cs.ru"
    
    static func makeEndpoint(_ path: String) -> URL {
        return URL(string: self.baseUrlString + "/api" + path)!
    }
    
    static func makeEndpoint(path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "memapi.htc-cs.ru"
        components.path = "/api\(path)"
        params.forEach { (key, value) in
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return components.url!
    }
}
