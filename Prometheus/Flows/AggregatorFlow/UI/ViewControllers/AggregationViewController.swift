//
//  AggregationViewController.swift
//  Prometheus
//
//  Created by Pyretttt on 31.10.2021.
//

import RxSwift
import FeatureIntermediate

class AggregationViewController: UIViewController {
	
	private let viewModel: AggregationViewModelProtocol
	private let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - Subjects
	
	private let didLoad = Observable<Void>.of(())
	private let didTapItem = PublishSubject<AggregationItemModel>()
	
	// MARK: - Visual elements
	
	private lazy var featuresCollectionView: UICollectionView = {
		let view = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionLayout())
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Pallete.Gray.gray1
		view.contentInsetAdjustmentBehavior = .scrollableAxes
		
		return view
	}()
	
	// MARK: - Lifecycle
	
	init(viewModel: AggregationViewModelProtocol) {
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
		bindOutput()
		bindInput()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.applyStyle(.standard)
		navigationItem.title = "Modules"
	}

	// MARK: - Setup UI
	
	private func configureCollectionView() {
		featuresCollectionView.dataSource = dataSource
		featuresCollectionView.delegate = self
		featuresCollectionView.register(PlainFeatureCell.self, forCellWithReuseIdentifier: PlainFeatureCell.reuseID)
		featuresCollectionView.register(SectionHeaderView.self,
										forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
										withReuseIdentifier: SectionHeaderView.reuseID)
	}
	
	private func setupUI() {
		configureCollectionView()
		
		let views = [featuresCollectionView]
		views.forEach { view.addSubview($0) }
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			featuresCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
			featuresCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			featuresCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			featuresCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	// MARK: - Data
	
	lazy var dataSource = AggregationDataSource(collectionView: featuresCollectionView, cellProvider: {
		[weak self] collectionView, indexPath, item in
		   let model = item.model
		   guard let cell = collectionView.dequeCell(cellModel: model, indexPath: indexPath) as? CollectionCellType else {
			   return UICollectionViewCell()
		   }
		   cell.setup(model: item.model)
		   return cell
	})
	
	private func bindInput() {
		viewModel.input.didLoad.onCompleted()
		didTapItem
			.subscribe(viewModel.input.didTapItem)
			.disposed(by: disposeBag)
	}
	
	private func bindOutput() {
		viewModel.output.items
			.subscribe(onNext: { [weak self] items in
				guard let self = self else { return }
				self.dataSource.add(items)
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - Layout

private extension AggregationViewController {
	func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout { [weak self] index, environment in
			guard let self = self else { return nil }
			return self.createListLayout()
		}
		
		layout.configuration.scrollDirection = .vertical
		return layout
	}
	
	func createListLayout() -> NSCollectionLayoutSection {
		let estimatedHeightSize = NSCollectionLayoutDimension.estimated(71)
		
		// supplementaries
		let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
		let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
																	 elementKind: UICollectionView.elementKindSectionHeader,
																	 alignment: .top)
		headerItem.contentInsets = NSDirectionalEdgeInsets(top: .zero,
														   leading: NumericValues.default,
														   bottom: .zero,
														   trailing: NumericValues.default)
		
		// items
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: estimatedHeightSize)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		// group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: estimatedHeightSize)
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		
		// section
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = NumericValues.default
		section.boundarySupplementaryItems = [headerItem]
		
		return section
	}
}

extension AggregationViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let item = dataSource.itemIdentifier(for: indexPath) else {
			collectionView.deselectItem(at: indexPath, animated: true)
			return
		}
		didTapItem.onNext(item)
	}
}
