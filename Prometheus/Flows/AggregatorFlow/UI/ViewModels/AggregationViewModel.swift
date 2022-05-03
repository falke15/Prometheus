//
//  AggregationViewModel.swift
//  Prometheus
//
//  Created by Pyretttt on 31.10.2021.
//

import RxSwift
import FeatureIntermediate

protocol AggregationViewModelProtocol {
	var input: AggregationViewModel.Input { get }
	var output: AggregationViewModel.Output { get }
}

final class AggregationViewModel: AggregationViewModelProtocol {
	
	struct Input {
		let didLoad: AnyObserver<AggregationViewController.LayoutType>
		let didTapItem: AnyObserver<AggregationItemModel>
        let didTapChangeLayoutItem: AnyObserver<AggregationViewController.LayoutType>
	}
	
	struct Output {
		let items: Observable<[Section<AggregationItemModel>]>
	}
	
	private(set) lazy var input: Input = {
		let didLoad = PublishSubject<AggregationViewController.LayoutType>()
		_ = didLoad
			.debug()
			.asSingle()
            .subscribe(onSuccess: { [weak self] layout in
                guard let self = self else { return }
                let info: [Section<AggregationItemModel>]
                
                switch layout {
                case .list:
                    info = self.getProductsInfo()
                case .slider:
                    info = self.getInfo()
                }
                self.storeInfo(items: info)
                self.itemsSubject.onNext(self.items)
            })
		
		let didTapItem = PublishSubject<AggregationItemModel>()
		didTapItem.subscribe(onNext: { item in
			switch item {
			case .plainFeature(let model):
				model.actionBlock()
            case .productFeature(let model):
                model.actionBlock()
			}
		})
		.disposed(by: disposeBag)
        
        let didTapChangeLayoutItem = PublishSubject<AggregationViewController.LayoutType>()
        didTapChangeLayoutItem.subscribe(onNext: { [weak self] layout in
            guard let self = self else { return }
            let info: [Section<AggregationItemModel>]
            
            switch layout {
            case .list:
                info = self.getProductsInfo()
            case .slider:
                info = self.getInfo()
            }
            self.storeInfo(items: info)
            self.itemsSubject.onNext(self.items)
        })
        .disposed(by: disposeBag)
		
		return Input(didLoad: didLoad.asObserver(),
					 didTapItem: didTapItem.asObserver(),
                     didTapChangeLayoutItem: didTapChangeLayoutItem.asObserver())
	}()
	
	private(set) lazy var output: Output = {
		Output(items: itemsSubject.asObservable())
	}()
	
	private let disposeBag: DisposeBag = DisposeBag()
	private let featureLoader: FeatureLoader
	
	private var items: [Section<AggregationItemModel>] = []
	
	// MARK: - Subjects
	
	private let itemsSubject: PublishSubject<[Section<AggregationItemModel>]> = PublishSubject()
	
	// MARK: - Lifecycle
	
	init(featureLoader: FeatureLoader) {
		self.featureLoader = featureLoader
	}
	
	// MARK: - Data

	private func getInfo() -> [Section<AggregationItemModel>] {
		let features = featureLoader.getFeatures()
		let aggregationItems: [AggregationItemModel] = features.map { feature in
			let actionBlock: () -> Void = { [weak feature] in
				feature?.enter()
			}
			let item = FeatureCellModel(name: feature.processName,
										description: feature.description,
										imageName: feature.imageName,
										actionBlock: actionBlock)
			return AggregationItemModel.plainFeature(model: item)
		}
		let sections: [Section<AggregationItemModel>] = [
			Section(name: "Features", isClosed: false, items: aggregationItems)
		]
		
		return sections
	}
    
    private func getProductsInfo() -> [Section<AggregationItemModel>] {
        let features = featureLoader.getFeatures()
        let aggregationItems: [AggregationItemModel] = features.map { feature in
            let actionBlock: () -> Void = { [weak feature] in
                feature?.enter()
            }
            let item = ProductFeatureModel(name: feature.processName,
                                           description: feature.description,
                                           imageName: feature.imageName,
                                           actionBlock: actionBlock)
            return AggregationItemModel.productFeature(model: item)
        }
        let sections: [Section<AggregationItemModel>] = [
            Section(name: "Features", isClosed: false, items: aggregationItems)
        ]
        
        return sections
    }
	
	private func storeInfo(items: [Section<AggregationItemModel>]) {
		self.items = items
	}
}
