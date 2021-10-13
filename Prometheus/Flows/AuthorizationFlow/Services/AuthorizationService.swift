//
//  AuthorizationService.swift
//  Prometheus
//
//  Created by Pyretttt on 26.09.2021.
//

import Foundation
import Security

protocol AuthorizationServiceProtocol {
	var isRegistered: Bool { get }
	
	func signIn(with password: String) throws -> Bool
	func setPassword(password: String) throws
}

class AuthorizationService: AuthorizationServiceProtocol {
	
	private enum AuthorizationError: Error {
		case wrongData
		case itemNotFound
		case unknownError
	}
	
	private enum Keys: String {
		case isRegistered
		case password
	}
	
	private static let userDefaults = UserDefaults.standard
	
	private let serviceName: String = Bundle.main.bundleIdentifier ?? "Prometheus"
	
	// MARK: - AuthorizationServiceProtocol
	
	private(set) var isRegistered: Bool {
		get {
			Self.userDefaults.bool(forKey: Keys.isRegistered.rawValue)
		}
		set {
			Self.userDefaults.setValue(newValue, forKey: Keys.isRegistered.rawValue)
		}
	}
	
	func signIn(with password: String) throws -> Bool {
		var result: CFTypeRef?
		let status = searchItem(itemDescription: Keys.password.rawValue, searchResult: &result)
		
		guard status != errSecItemNotFound, status == errSecSuccess else {
			let error: AuthorizationError = status == errSecItemNotFound ?
				.itemNotFound :
				.unknownError
			throw error
		}
		
		guard let data = result as? Data,
			  let storedPassword = String(data: data, encoding: .utf8) else {
			throw AuthorizationError.wrongData
		}
		
		return storedPassword == password
	}
	
	func setPassword(password: String) throws {
		guard let data = password.data(using: .utf8) else {
			throw AuthorizationError.wrongData
		}
		
		let status = storeSingleValue(data: data, itemDescription: Keys.password.rawValue)
		if status == errSecDuplicateItem {
			try updateItem(itemDescription: Keys.password.rawValue,
						   updatedAttributes: [kSecValueData: data])
			isRegistered = true
			return
		}
		
		if status == errSecSuccess {
			isRegistered = true
			return
		}
		throw AuthorizationError.unknownError
	}
}

private extension AuthorizationService {
	func removeItem(itemDescription: String) {
		let item: [CFString: Any] = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: serviceName,
			kSecAttrDescription: itemDescription
		]
		_ = SecItemDelete(item as CFDictionary)
	}
	
	func searchItem(itemDescription: String, searchResult: inout CFTypeRef?) -> OSStatus {
		let item: [CFString: Any] = [
			kSecClass: kSecClassGenericPassword,
			kSecAttrService: serviceName,
			kSecAttrDescription: itemDescription,
			kSecReturnData: true as CFBoolean,
			kSecMatchLimit: kSecMatchLimitOne
		]
		let status = SecItemCopyMatching(item as CFDictionary, &searchResult)
		
		return status
	}
	
	func storeSingleValue(data: Data, itemDescription: String) -> OSStatus {
		let item: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
									 kSecAttrService: serviceName,
									 kSecAttrDescription: itemDescription,
									 kSecValueData: data]
		let status = SecItemAdd(item as CFDictionary, nil)
		
		return status
	}
	
	func updateItem(itemDescription: String, updatedAttributes: [CFString: Any]) throws {
		let item: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
									 kSecAttrService: serviceName,
									 kSecAttrDescription: itemDescription]
		let status = SecItemUpdate(item as CFDictionary, updatedAttributes as CFDictionary)
		guard status == errSecSuccess else {
			throw AuthorizationError.unknownError
		}
	}
}
