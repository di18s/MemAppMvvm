//
//  APIMethod.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

enum APIMethod {
    case mems(offset: Int, count: Int, desc: Bool)
    case pic
    case title(title: String)
    case mem(titleId: Int, picId: Int)
    case pics(select: Int, count: Int)
    case titles(select: Int, count: Int)
}

extension APIMethod {
    var url: URL {
        switch self {
        case let .mems(offset, count, desc):
            return .makeEndpoint("/mem?offset=\(offset)&count=\(count)&desc=\(desc)")
        case .pic:
            return .makeEndpoint("/pic")
        case .title(let title):
            return .makeEndpoint(path: "title", params: ["title": title])
        case let .mem(titleId, picId):
            return .makeEndpoint("/mem?titleId=\(titleId)&picId=\(picId)")
        case let .pics(select, count):
            return .makeEndpoint("/pic/rand?select=\(select)&count=\(count)")
        case let .titles(select, count):
            return .makeEndpoint("/title/rand?select=\(select)&count=\(count)")
        }
    }
}
