//
//  AggregatorViewController.swift
//  Prometheus
//
//  Created by Pyretttt on 30.09.2021.
//

import UIKit

final class AggregatorViewController: UIViewController {
		
	// MARK: - Views
	
	private let compositionalLayout: UICollectionViewLayout = {
		let layout = UICollectionViewFlowLayout()
		
		return layout
	}()
	
	private lazy var collectionView: UICollectionView = {
		let view = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
		
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
		view.backgroundColor = Pallete.Black.black1
		navigationItem.title = "Выбирай модуль"
		
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			
		])
	}
	
}
