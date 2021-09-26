//
//  AuthViewModel.swift
//  rxLearn
//
//  Created by Pyretttt on 29.08.2021.
//

import RxSwift
import RxCocoa

protocol AuthViewModelType {
	associatedtype Input
	associatedtype Output
	
	func transform(input: Input) -> Output
}

class AuthViewModel: AuthViewModelType {

	// MARK: - AuthViewModelType
	
	struct Input {
		
	}

	struct Output {
		let state: Driver<AuthViewModel.State>
	}
	
	func transform(input: Input) -> Output {
		Output(state: state.asDriver(onErrorJustReturn: .failure))
	}
	
	// MARK: - Lifecycle
	
	init(state: AuthViewModel.State) {
		self.state = PublishSubject<AuthViewModel.State>()
	}
	
	// MARK: - AuthViewModelOutput

	private(set) var state: PublishSubject<AuthViewModel.State>
	
}

extension AuthViewModel {
	
	/// Состояние процесса авторизации
	enum State {
		case create
		case confirm
		case enter
		case success
		case failure
	}
}
