//
//  AggregatorViewController.swift
//  Prometheus
//
//  Created by Pyretttt on 30.09.2021.
//

import UIKit
import FeatureIntermediate
import RxSwift

final class AggregatorViewController: UIViewController {
	
	private let viewModel: AggregationViewModelType
	private let disposeBag = DisposeBag()
	
	// MARK: - Subjects
	
	private let loaded = PublishSubject<Void>()
	
	// MARK: - Views
	
	private lazy var featureCollectionView: UICollectionView = {
		let view = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
		view.register(AggregatorFeatureCell.self, forCellWithReuseIdentifier: AggregatorFeatureCell.reuseID)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Delegates
	
	private lazy var dataSource: AggregationDataSource<FeatureAdapterCellModel> = {
		let dataSource = AggregationDataSource(collectionView: featureCollectionView) {
			[weak self] (collectionView: UICollectionView,
						 indexPath: IndexPath,
						 itemIdentifier: FeatureAdapterCellModel) -> UICollectionViewCell in
			guard let self = self else { return UICollectionViewCell() }
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeatureAdapterCellModel.Cell.reuseID,
																for: indexPath) as? CollectionCellType else {
				return UICollectionViewCell()
			}
			
			cell.setup(model: itemIdentifier)
			return cell
		}
		return dataSource
	}()
	
	// MARK: - Lifecycle
	
	init(viewModel: AggregationViewModelType) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		bindInput()
		bindOutput()
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Pallete.Black.black1
		
		loaded.onCompleted()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = "Выбирай модуль"
	}
	
	// MARK: - Setup Data
	
	private func bindInput() {
		loaded
			.bind(to: viewModel.input.viewDidLoad)
			.disposed(by: disposeBag)
	}
	
	private func bindOutput() {
		viewModel.output.items
			.subscribe(onNext: { [weak self] items in
				guard let self = self else { return }
				let features: [FeatureAdapterCellModel] = items.map { item in
					let action: () -> Void = { [weak item] in
						item?.start(params: nil)
					}
					return FeatureAdapterCellModel(name: item.name,
													 image: item.image ?? UIImage(),
													 id: item.identifier,
													 action: action)
				}
				self.dataSource.update(with: features)
			})
			.disposed(by: disposeBag)
	}
	
	// MARK: - Setup UI
	
	private func setupUI() {
		configureCollectionView()
		
		view.addSubview(featureCollectionView)
		setupConstraints()
	}
	
	private func configureCollectionView() {
		featureCollectionView.dataSource = dataSource
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			featureCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			featureCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			featureCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			featureCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

extension AggregatorViewController {
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewFlowLayout()
		
		return layout
	}
}
