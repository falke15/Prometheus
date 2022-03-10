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
	}
	
	private let viewModel: AggregationViewModelProtocol
	private let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - Subjects
	
	private let didLoad = Observable<Void>.of(())
	private let didTapItem = PublishSubject<AggregationItemModel>()
	
	// MARK: - Visual elements
	
	private lazy var featuresCollectionView: UICollectionView = {
        let layout = TransformCollectionLayout()
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = Constants.primaryColor
		view.translatesAutoresizingMaskIntoConstraints = false
		
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
		navigationItem.title = "Modules"
	}

	// MARK: - Setup UI
	
	private func configureCollectionView() {
		featuresCollectionView.dataSource = dataSource
		featuresCollectionView.delegate = self
		featuresCollectionView.register(PlainFeatureCell.self, forCellWithReuseIdentifier: PlainFeatureCell.reuseID)
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

extension AggregationViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let item = dataSource.itemIdentifier(for: indexPath) else {
			collectionView.deselectItem(at: indexPath, animated: true)
			return
		}
		didTapItem.onNext(item)
	}
}
