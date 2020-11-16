//
//  Collection+Extension.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
