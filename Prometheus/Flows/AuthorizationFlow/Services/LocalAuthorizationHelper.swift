//
//  LocalAuthorizationHelper.swift
//  Prometheus
//
//  Created by Pyretttt on 06.10.2021.
//

import LocalAuthentication
import RxSwift

protocol LocalAuthorizationHelperProtocol {
	var isBiometryAvailable: Bool { get }
	
	/// Запросить локальную авторизация
	/// - Returns: Признак успешной авторизации
	func requestLocalAuthorization() -> Single<Bool>
}

struct LocalAuthorizationHelper: LocalAuthorizationHelperProtocol {
	private let context: LAContext = LAContext()
	
	var isBiometryAvailable: Bool {
		var error: NSError?
		let isEnabled = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
		return isEnabled
	}
	
	func requestLocalAuthorization() -> Single<Bool> {
		guard isBiometryAvailable else { return Observable.just(false).asSingle() }
		
		let sequence = Single<Bool>.create { single in
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
								   localizedReason: "Войдите в приложение") { success, error in
				if let error = error {
					print(error.localizedDescription)
					single(.success(false))
					
				}
				guard success else {
					single(.success(false))
					return
				}
				single(.success(true))
			}
			
			return Disposables.create()
		}
		
		return sequence
	}
}
