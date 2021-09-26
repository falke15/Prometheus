//
//  AuthViewController.swift
//  rxLearn
//
//  Created by Pyretttt on 10.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

class AuthViewController: UIViewController {
	
	private enum Values {
		static let pinBoardHeight: CGFloat = 400
		static let pinBoardHeaderHeight: CGFloat = 56
	}
	
	// MARK: - Private properties

	private let disposeBag = DisposeBag()

	// MARK: - Views
	
	private let progressView: DotProgressView = {
		let view = DotProgressView(dotsCount: 4)
		view.setStatusText(text: "Введите пароль")
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
		let view = PinBoardView(isBiometricEnabled: true, delegate: self)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Lifecycle
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
	
		setupUI()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		timerLabel.startAnimating()
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
			
			pinBoardView.heightAnchor.constraint(equalToConstant: Values.pinBoardHeight),
			pinBoardView.widthAnchor.constraint(equalTo: view.widthAnchor),
			pinBoardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pinBoardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
		])
	}
}

extension AuthViewController: PinBoardDelegate {
	func onNumEntered(num: Int) {
		pinBoardView.setRemoveOperationAvailability(true)
		progressView.increment()
	}
	
	func onRemove() {
		progressView.decrement()
	}
}
