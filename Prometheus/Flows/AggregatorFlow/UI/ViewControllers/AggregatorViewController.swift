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
		view.backgroundColor = Pallete.Gray.gray1
		view.register(PromoFeatureCell.self, forCellWithReuseIdentifier: PromoFeatureCell.reuseID)
		view.register(SquareInfoFeatureCell.self, forCellWithReuseIdentifier: SquareInfoFeatureCell.reuseID)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
	// MARK: - Delegates
	
	private lazy var dataSource: AggregationDataSource = {
		let dataSource = AggregationDataSource(collectionView: featureCollectionView) {
			[weak self] (collectionView: UICollectionView,
						 indexPath: IndexPath,
						 itemIdentifier: AnyHashable) -> UICollectionViewCell in
			
			guard let model = itemIdentifier as? CollectionCellModelAnyType,
				  let cell = collectionView.dequeCell(cellModel: model,
													  indexPath: indexPath) as? CollectionCellType else {
				return UICollectionViewCell()
			}
			
			cell.setup(model: model)
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
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		extendedLayoutIncludesOpaqueBars = true
		
		// В конце всех настроек, иначе layout будет кидать ворнинги
		loaded.onCompleted()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = "Modules"
		
		navigationController?.navigationBar.applyStyle(.standard)
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
				self.dataSource.update(with: items)
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

// MARK: - Layout

extension AggregatorViewController {
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { idx, environment in
			switch idx {
			case 0:
				return self.createPromoSection(environment: environment)
			case 1:
				return self.createBunchSection(environment: environment)
			default:
				return self.createListSection(environment: environment)
			}
		}
		
		layout.configuration.scrollDirection = .vertical
		return layout
	}
	
	func createPromoSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		let defaultInset = NumericValues.default
		// Items
		let promoItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
												   heightDimension: .fractionalHeight(1))
		let promoItem = NSCollectionLayoutItem(layoutSize: promoItemSize)
		promoItem.contentInsets = NSDirectionalEdgeInsets(top: defaultInset,
														  leading: defaultInset,
														  bottom: defaultInset,
														  trailing: defaultInset)
		
		// Groups
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											   heightDimension: .fractionalWidth(0.65))
		let group =	NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [promoItem])
		
		// Sections
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .paging
		
		return section
	}
	
	func createBunchSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		let defaultInset = NumericValues.extraSmall
		let insetBig = NumericValues.medium
		// Items
		let baseItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
												  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: baseItemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: defaultInset,
													 leading: defaultInset,
													 bottom: defaultInset,
													 trailing: defaultInset)

		// Groups
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
		
		// Sections
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		section.contentInsets = NSDirectionalEdgeInsets(top: .zero,
														leading: insetBig,
														bottom: .zero,
														trailing: insetBig)
		
		return section
	}
	
	func createListSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		let defaultOffset = NumericValues.large
		let smallOffset = NumericValues.small
		// Items
		let baseItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
												  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: baseItemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: smallOffset,
													 leading: defaultOffset,
													 bottom: smallOffset,
													 trailing: defaultOffset)
		
		// Groups
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
		
		// Sections
		let section = NSCollectionLayoutSection(group: group)
		
		return section
	}
}
