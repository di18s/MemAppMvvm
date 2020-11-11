//
//  DecodableExtension.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeURLIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> URL? {
        if let urlString = try self.decodeIfPresent(String.self, forKey: key) {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
    
    func decodeIfPresent<T: Decodable>(forKey key: K) throws -> T? {
        if T.self == URL.self {
            return try self.decodeURLIfPresent(forKey: key) as? T
        } else {
            return try self.decodeIfPresent(T.self, forKey: key)
        }
    }
    
    func decode<T: Decodable>(forKey key: K) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
}
