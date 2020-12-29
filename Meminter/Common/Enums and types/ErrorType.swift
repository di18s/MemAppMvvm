//
//  ErrorType.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 27.11.2020.
//

import Foundation

enum ErrorType: Error {
	case localized(_ errorDescription: String?)
}

