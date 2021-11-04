//
//  AuthViewModel.swift
//  rxLearn
//
//  Created by Pyretttt on 29.08.2021.
//

import RxSwift
import RxCocoa
import FeatureIntermediate

class AuthViewModel: ViewModelType {
	
	// MARK: - Input/Output
	
	struct Input {
		let passwordDidEntered: Observable<String>
		let viewDidLoad: Single<Void>
		let attemptBiometryAuth: Observable<Void>
	}

	struct Output {
		let state: Driver<State>
		let biometryEnabled: Driver<Bool>
	}
	
	private let state = BehaviorSubject<AuthViewModel.State>(value: .enter("Добро пожаловать"))
	private let biometryEnabled = BehaviorSubject<Bool>(value: false)
	
	// MARK: - Properties

	private let authorizationService: AuthorizationServiceProtocol
	private let disposeBag = DisposeBag()
	private let localAuthorizationHelper: LocalAuthorizationHelperProtocol
	private weak var flowCoordinating: AuthCoordinating?
	
	private var passwordBuffer: String = ""
	
	// MARK: - Lifecycle
	
	init(authorizationService: AuthorizationServiceProtocol,
		 localAuthorizationHelper: LocalAuthorizationHelperProtocol,
		 flowCoordinating: AuthCoordinating) {
		self.authorizationService = authorizationService
		self.localAuthorizationHelper = localAuthorizationHelper
		self.flowCoordinating = flowCoordinating
	}
	
	// MARK: - ViewModelType
	
	func transform(input: Input) -> Output {
		input.viewDidLoad
			.subscribe { [weak self] _ in
				self?.loadInfo()
				self?.bindBiometryWithState()
			}
			.dispose()
		
		input.attemptBiometryAuth
			.subscribe { [weak self] _ in
				self?.attemptLocalAuthorization()
			}
			.disposed(by: disposeBag)
		
		input.passwordDidEntered
			.filter { $0.count == 4 }
			.subscribe(onNext: { [weak self] pass in
				guard let self = self else { return }
				
				switch try? self.state.value() {
				case .enter:
					self.signIn(with: pass)
				case .create:
					self.writeBufferPassword(password: pass)
				case .confirm:
					// Попытка сохранить пароль, если пароли не совпадают - переводим на повторное создание
					pass == self.passwordBuffer ?
						self.setPassword(pass) :
						self.loadInfo(createText: Constants.passwordNotMatching)
				case .unknownError:
					self.authorizationService.isRegistered ?
						self.signIn(with: pass) :
						self.writeBufferPassword(password: pass)
				default:
					// Не должно быть попыток ввода пароля после авторизации и других кейсов
					fatalError("Нарушен процесс авторизаций недоступный сценарий")
				}
			})
			.disposed(by: disposeBag)
		
		return Output(state: state.asDriver(onErrorJustReturn: .enter(Constants.defaultError)),
					  biometryEnabled: biometryEnabled.asDriver(onErrorJustReturn: false))
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
				self.forceLogin()
			} else {
				state.onNext(.enter(Constants.wrongPass))
			}
		} catch {
			state.onNext(.enter(Constants.defaultError))
		}
	}
	
	private func forceLogin() {
		state.onNext(.success("Успешно"))
		flowCoordinating?.completeAuthorization()
	}
	
	private func writeBufferPassword(password: String) {
		passwordBuffer = password
		state.onNext(.confirm("Повторите пароль"))
	}
	
	private func setPassword(_ password: String) {
		do {
			try authorizationService.setPassword(password: password)
			forceLogin()
		} catch {
			print(error)
			passwordBuffer = ""
			state.onNext(.create(Constants.defaultError))
		}
	}
	
	private func bindBiometryWithState() {
		state
			.map { [weak self] state in
				guard let self = self else { return false }
				switch state {
				case .enter:
					return self.localAuthorizationHelper.isBiometryAvailable && self.authorizationService.isRegistered
				default:
					return false
				}
			}
			.bind(to: biometryEnabled)
			.disposed(by: disposeBag)
	}
	
	private func attemptLocalAuthorization() {
		// Диспоузится самостоятельно после получения ответа от сервиса
		_ = localAuthorizationHelper.requestLocalAuthorization()
			.debug()
			.observe(on: MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] succeeded in
				guard let self = self else { return }
				if succeeded {
					self.forceLogin()
				} else {
					self.state.onNext(.enter(Constants.defaultError))
				}
			})
	}
}

extension AuthViewModel {

	private enum Constants {
		static let defaultError: String = "Произошла ошибка"
		static let wrongPass: String = "Неверный пароль"
		static let passwordNotMatching: String = """
												Пароли не совпадают
												попробуйте еще раз
												"""
	}
	
	/// Состояние процесса авторизации
	enum State {
		case create(String)
		case confirm(String)
		case enter(String)
		case success(String)
		case unknownError(String)
	}
}
