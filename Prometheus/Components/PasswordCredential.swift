//
//  PasswordCredential.swift
//  Prometheus
//
//  Created by Pyretttt on 28.09.2021.
//

import Foundation

/// Обертка с логикой валидации посимвольного ввода пароля
@propertyWrapper struct PasswordCredential {	
	private let lenght: Int
	private var _password: String = ""
	
	var wrappedValue: String {
		get { _password }
		
		set {
			if _password.count < lenght && newValue.count == 1 {
				_password.append(newValue)
			}
		}
	}
	
	var projectedValue: String {
		return _password
	}
	
	// MARK: - Lifecycle
	
	init(lenght: Int) {
		self.lenght = lenght
	}
	
	// MARK: - Helpers
	
	mutating func deleteLastChar() {
		_password = String(_password.dropLast())
	}
	
	mutating func emptify() {
		_password = ""
	}
}
