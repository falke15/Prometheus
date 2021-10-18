//
//  PinBoardView.swift
//  exKeeper
//
//  Created by Pyretttt on 04.09.2021.
//

import UIKit

public protocol PinBoardDelegate: AnyObject {
	/// Обработка введения цифры
	func onNumEntered(num: Int)
	
	/// Удаление числа из прогресса
	func onRemove()
}

public final class PinBoardView: UIView {
	
	private enum Values {
		static let defaultSpacing: CGFloat = NumericValues.default
	}
	
	weak var delegate: PinBoardDelegate?
	
	// MARK: - Pins
	
	private var pins: [PinInfo] = []
	private lazy var numericPins: [PinInfo] = {
		var result: [PinInfo] = []
		for index in 1...10 {
			var number = index == 10 ? 0 : index
			let action: () -> Void = { [weak self] in
				self?.delegate?.onNumEntered(num: number)
			}
			result.append(PinInfo(number: number, action: action))
		}
		return result
	}()
	private lazy var customPin: PinInfo = {
		PinInfo(number: nil, action: nil, icon: nil, isEnabled: false)
	}()
	private lazy var removePin: PinInfo = {
		let deleteAction: () -> Void = { [weak self] in
			self?.delegate?.onRemove()
		}
		return PinInfo(number: nil, action: deleteAction, icon: ImageSource.remove.image, isEnabled: false)
	}()
	
	// MARK: - Views
	
	private lazy var collectionLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = Values.defaultSpacing
		layout.minimumLineSpacing = Values.defaultSpacing
		
		return layout
	}()

	private lazy var collectionView: UICollectionView = {
		let view = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
		view.dataSource = self
		view.delegate = self
		let backgroundView = UIView()
		view.backgroundColor = .clear
		view.backgroundView = backgroundView
		view.isScrollEnabled = false
		view.allowsSelection = true
		view.register(PinButtonCollectionCell.self, forCellWithReuseIdentifier: PinButtonCollectionCell.reuseID)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Lifecycle
	
	init(delegate: PinBoardDelegate?){
		self.delegate = delegate
		super.init(frame: .zero)
		
		setupPins()
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Data
	
	func setCustomPin(icon: UIImage,
					  action: @escaping () -> Void) {
		customPin.icon = icon
		customPin.action = action
		setupPins()
	}
	
	func setCustomPinEnabled(_ isEnabled: Bool) {
		customPin.isEnabled = isEnabled
		setupPins()
	}
	
	func setRemovingAvailable(_ enabled: Bool) {
		removePin.isEnabled = enabled
		setupPins()
	}
	
	private func setupPins() {
		var result = numericPins
		result.insert(customPin, at: numericPins.count - 1)
		result.append(removePin)
		self.pins = result
		collectionView.reloadData()
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		addSubview(collectionView)
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: topAnchor),
			collectionView.heightAnchor.constraint(equalTo: heightAnchor),
			collectionView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
			collectionView.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
}

extension PinBoardView: UICollectionViewDataSource {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pins.count
	}
	
	public func collectionView(_ collectionView: UICollectionView,
							   cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let model = pins[indexPath.item]
		return collectionView.dequeCell(cellModel: model, indexPath: indexPath)
	}
}

extension PinBoardView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView,
							   layout collectionViewLayout: UICollectionViewLayout,
							   sizeForItemAt indexPath: IndexPath) -> CGSize {
		let collectionSize = collectionView.frame.size
		let itemsHeight = collectionSize.height - Values.defaultSpacing * 3
		let itemHeight = itemsHeight / 4
		let itemsWidth = collectionSize.width - Values.defaultSpacing * 2
		let itemWidth = itemsWidth / 3
		
		return CGSize(width: itemWidth, height: itemHeight)
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let model = pins[indexPath.item]
		model.action?()
	}
	
	public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		let model = pins[indexPath.item]
		return model.isEnabled
	}
}

extension PinBoardView {
	
	struct PinInfo: CollectionCellModelType {
		typealias Cell = PinButtonCollectionCell
		
		let number: Int?
		var isEnabled: Bool
		var icon: UIImage?
		var action: (() -> Void)?
		
		init(number: Int?,
			 action: (() -> Void)?,
			 icon: UIImage? = nil,
			 isEnabled: Bool = true) {
			self.number = number
			self.icon = icon
			self.isEnabled = isEnabled
			self.action = action
		}
	}
}
