//
//  Collection+Extension.swift
//  Meminter
//
//  Created by Дмитрий Х on 11.11.2020.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
