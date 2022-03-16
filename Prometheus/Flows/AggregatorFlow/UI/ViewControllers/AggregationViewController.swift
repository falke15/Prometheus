//
//  AggregationViewController.swift
//  Prometheus
//
//  Created by Pyretttt on 31.10.2021.
//

import RxSwift
import FeatureIntermediate

class AggregationViewController: UIViewController {
	
	private enum Constants {
		static let primaryColor: UIColor = Pallete.Gray.gray1
        
        static let defaultOffset: CGFloat = NumericValues.default
        static let iconSize: CGFloat = NumericValues.xLarge
	}
    
    enum LayoutType {
        case list
        case slider
    }
	
	private let viewModel: AggregationViewModelProtocol
	private let disposeBag: DisposeBag = DisposeBag()
    private var layoutType: LayoutType = .list
	
	// MARK: - Subjects
	
	private let didTapItem = PublishSubject<AggregationItemModel>()
    private let didTapChangeLayoutItem = PublishSubject<LayoutType>()
	
	// MARK: - Visual elements
	
    private lazy var sliderLayout: UICollectionViewLayout = TransformCollectionLayout()
    private lazy var listLayout: UICollectionViewLayout = makeCollectionLayout()
    
	private lazy var featuresCollectionView: UICollectionView = {
		let view = UICollectionView(frame: .zero, collectionViewLayout: getCurrentLayout())
        view.contentInsetAdjustmentBehavior = .always
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Constants.primaryColor
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view
	}()
	
    private lazy var changeLayoutBarButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: Constants.iconSize),
            view.widthAnchor.constraint(equalToConstant: Constants.iconSize)
        ])
        view.setImage(ImageSource.ic64_up_and_down_arrows.image.withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = Pallete.Black.black4
        view.addTarget(self, action: #selector(didTapChangeLayout(sender:)), for: .touchUpInside)
        
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
		view.backgroundColor = Constants.primaryColor
		
		setupUI()
		bindOutput()
		bindInput()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)
		navigationController?.navigationBar.applyStyle(.standard)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: changeLayoutBarButton)
		navigationItem.title = "Modules"
	}

	// MARK: - Setup UI
	
	private func configureCollectionView() {
		featuresCollectionView.dataSource = dataSource
		featuresCollectionView.delegate = self
		featuresCollectionView.register(PlainFeatureCell.self,
                                        forCellWithReuseIdentifier: PlainFeatureCell.reuseID)
        featuresCollectionView.register(PlainFeatureCellHorizontal.self,
                                        forCellWithReuseIdentifier: PlainFeatureCellHorizontal.reuseID)
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
			featuresCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            featuresCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultOffset),
			featuresCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultOffset),
            featuresCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
    
    private func getCurrentLayout() -> UICollectionViewLayout {
        switch layoutType {
        case .list:
            return listLayout
        case .slider:
            return sliderLayout
        }
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
        viewModel.input.didLoad.onNext(layoutType)
		viewModel.input.didLoad.onCompleted()
		didTapItem
			.subscribe(viewModel.input.didTapItem)
			.disposed(by: disposeBag)
        
        didTapChangeLayoutItem
            .do(onNext: { [weak self] layout in
                guard let self = self else { return }
                self.layoutType = layout
                self.featuresCollectionView.setCollectionViewLayout(self.getCurrentLayout(), animated: true) { _ in
                    // I'w loved to know why collectionView breaks without it
                    self.featuresCollectionView.alwaysBounceVertical = self.getCurrentLayout() === self.listLayout
                }
                self.featuresCollectionView.contentOffset = .zero
            })
            .subscribe(viewModel.input.didTapChangeLayoutItem)
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
    
    // MARK: - Actions
    
    @objc
    private func didTapChangeLayout(sender: UIButton) {
        sender.tintColor = sender.tintColor == Pallete.Black.black4 ?
            Pallete.Orange.orange1 :
            Pallete.Black.black4
        
        switch layoutType {
        case .list:
            didTapChangeLayoutItem.onNext(.slider)
        case .slider:
            didTapChangeLayoutItem.onNext(.list)
        }
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
