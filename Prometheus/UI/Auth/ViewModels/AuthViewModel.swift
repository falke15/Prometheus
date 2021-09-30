//
//  AuthViewModel.swift
//  rxLearn
//
//  Created by Pyretttt on 29.08.2021.
//

import RxSwift
import RxCocoa

class AuthViewModel: ViewModelType {
	
	// MARK: - Input/Output
	
	struct Input {
		let passwordDidEntered: Observable<String>
		let viewDidLoad: Single<Void>
	}

	struct Output {
		let state: Driver<State>
	}
	
	private(set) var state = BehaviorSubject<AuthViewModel.State>(value: .enter("Добро пожаловать"))
	
	// MARK: - Properties

	private let authorizationService: AuthorizationServiceProtocol
	private var disposeBag = DisposeBag()
	private weak var flowCoordinating: AuthCoordinating?
	
	// MARK: - Lifecycle
	
	init(authorizationService: AuthorizationServiceProtocol,
		 flowCoordinating: AuthCoordinating) {
		self.authorizationService = authorizationService
		self.flowCoordinating = flowCoordinating
		
		loadInfo()
	}
	
	// MARK: - ViewModelType
	
	func transform(input: Input) -> Output {
		input.passwordDidEntered
			.filter { $0.count == 4 }
			.subscribe(onNext: { [weak self] pass in
				guard let self = self else { return }
				
				switch try? self.state.value() {
				case .enter:
					self.signIn(with: pass)
				case .create:
					self.setPassword(pass)
				case .confirm:
					// Попытка авторизоваться, под только что установленным паролем
					self.signIn(with: pass)
				case .failure:
					self.loadInfo(enterText: "Попробуйте еще раз",
								  createText: "Пароли не совпали")
				default:
					// Не должно быть попыток ввода пароля после
					fatalError("Нарушен процесс авторизаций недоступный сценарий")
				}
			})
			.disposed(by: disposeBag)
		
		return Output(state: state.asDriver(onErrorJustReturn: .failure(Constants.defaultError)))
	}
	
	// MARK: - Processing
	
	private func loadInfo(enterText: String = "Введите пароль",
						  createText: String = "Придумайте пароль") {
		authorizationService.isRegistered ?
			state.onNext(.enter(enterText)) :
			state.onNext(.create(createText))
	}
	
	private func signIn(with password: String) {
		do {
			if try authorizationService.signIn(with: password) {
				state.onNext(.success("Успешный вход"))
				
			} else {
				state.onNext(.failure(Constants.wrongPass))
			}
		} catch {
			state.onNext(.failure(Constants.defaultError))
		}
	}
	
	private func setPassword(_ password: String) {
		do {
			try authorizationService.setPassword(password: password)
			state.onNext(.confirm("Повторите пароль"))
		} catch {
			print(error)
			state.onNext(.failure(Constants.unknownError))
		}
	}
	
}

extension AuthViewModel {

	private enum Constants {
		static let defaultError: String = "Произошла ошибка"
		static let unknownError: String = "Произошла неизвестная ошибка"
		static let wrongPass: String = "Неверный пароль"
	}
	
	/// Состояние процесса авторизации
	enum State {
		case create(String)
		case confirm(String)
		case enter(String)
		case success(String)
		case failure(String)
	}
}
