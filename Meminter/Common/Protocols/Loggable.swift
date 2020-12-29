//
//  Loggable.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 27.11.2020.
//

import Foundation

protocol LoggableInput: class {
	func log(_ response: URLResponse?)
}

extension LoggableInput {
	func log(_ response: URLResponse?) {
		if let response = response as? HTTPURLResponse {
			print(response.url as Any, " - ", response.statusCode)
		}
	}
}
