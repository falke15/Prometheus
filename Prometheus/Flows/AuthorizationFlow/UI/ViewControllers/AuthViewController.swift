//
//  AuthViewController.swift
//  rxLearn
//
//  Created by Pyretttt on 10.06.2021.
//

import FeatureIntermediate
import RxSwift
import RxCocoa

class AuthViewController: UIViewController, PinBoardDelegate {
	
	private enum Values {
		static let pinBoardHeaderHeight: CGFloat = 64
	}

	@PasswordCredential(lenght: 4)
	private var currentPasswordProgress: String
	
	private let viewModel: AuthViewModel
	private let disposeBag = DisposeBag()
	
	// MARK: - Subjects
	
	private let password = PublishSubject<String>()
	private let attemptBiometryAuth = PublishSubject<Void>()
	private let onViewDidload = Observable<Void>.of(())

	// MARK: - Visual elements
	
	private let progressView: DotProgressView = {
		let view = DotProgressView(dotsCount: 4)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	private let timerLabel: TimerLabel = {
		let view = TimerLabel()
		view.text = "Загрузка"
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()

	private lazy var pinBoardView: PinBoardView = {
		let view = PinBoardView(delegate: self)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Lifecycle
	
	init(viewModel: AuthViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		setupBiometry()
		bind()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: false)
		timerLabel.startAnimating()
	}
	
	// MARK: - Setup Data
	
	private func bind() {
		let input = AuthViewModel.Input(passwordDidEntered: password.asObservable(),
										viewDidLoad: onViewDidload.asSingle(),
										attemptBiometryAuth: attemptBiometryAuth.asObservable())
		let output = viewModel.transform(input: input)
		output.state
			.drive { [weak self] state in
				guard let self = self else { return }
				self.pinBoardView.isUserInteractionEnabled = true
				
				var title: String
				switch state {
				case .enter(let text):
					title = text
				case .create(let text):
					title = text
				case .confirm(let text):
					title = text
				case .success(let text):
					title = text
					self.pinBoardView.isUserInteractionEnabled = false
				case .unknownError(let text):
					title = text
				}
				self.resetCurrentInput()
				self.progressView.setStatusText(text: title, animated: true)
			}
		.disposed(by: disposeBag)
		
		output.biometryEnabled
			.drive { [weak self] isEnabled in
				self?.pinBoardView.setCustomPinEnabled(isEnabled)
			}
			.disposed(by: disposeBag)
	}
	
	private func resetCurrentInput() {
		progressView.resetProgress()
		_currentPasswordProgress.emptify()
		pinBoardView.setRemovingAvailable(false)
	}
	
	private func setupBiometry() {
		pinBoardView.setCustomPin(icon: ImageSource.biometry.image) { [weak self] in
			self?.attemptBiometryAuth.onNext(())
		}
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		view.backgroundColor = Pallete.Light.white1
		
		let views = [pinBoardView, progressView, timerLabel]
		views.forEach { view.addSubview($0) }
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			progressView.bottomAnchor.constraint(equalTo: pinBoardView.topAnchor, constant: -NumericValues.default),
			progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			progressView.heightAnchor.constraint(equalToConstant: Values.pinBoardHeaderHeight),
			
			pinBoardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
			pinBoardView.widthAnchor.constraint(equalTo: view.widthAnchor),
			pinBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pinBoardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		])
	}
	
	// MARK: - PinBoardDelegate
	
	func onNumEntered(num: Int) {
		progressView.increment()
		currentPasswordProgress = String(num)
		// Эммитим каждый введенный символ
		password.onNext($currentPasswordProgress)
		
		if $currentPasswordProgress.count > 0 {
			pinBoardView.setRemovingAvailable(true)
		}
	}
	
	func onRemove() {
		progressView.decrement()
		_currentPasswordProgress.deleteLastChar()
		// Эмиттим каждый удаленный символ
		password.onNext($currentPasswordProgress)
		
		if $currentPasswordProgress.isEmpty {
			pinBoardView.setRemovingAvailable(false)
		}
	}
}
