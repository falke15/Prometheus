//
//  AggregationViewModel.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import Foundation
import FeatureIntermediate
import RxSwift

protocol AggregationViewModelType {
	var input: AggregationViewModel.Input { get }
	var output: AggregationViewModel.Output { get }
}

final class AggregationViewModel: AggregationViewModelType {
	
	private let featureLoader: FeatureLoader
	private let disposeBag = DisposeBag()
	
	// MARK: - AggregationViewModelType
	
	struct Input {
		var viewDidLoad: AnyObserver<Void>
	}
	
	struct Output {
	 	var items: Observable<[Section<AnyHashable>]>
 	}
	
	private(set) lazy var input: Input = {
		let viewDidLoad = PublishSubject<Void>()
		_ = viewDidLoad
			.debug()
			.asSingle()
			.subscribe { [weak self] _ in
				guard let self = self else { return }
				self.loadFeatures()
			}
		return Input(viewDidLoad: viewDidLoad.asObserver())
	}()
	
	private(set) lazy var output: Output = {
		Output(items: features.asObservable())
	}()
	
	private let features = PublishSubject<[Section<AnyHashable>]>()
	
	// MARK: - Lifecycle
	
	init(featureLoader: FeatureLoader) {
		self.featureLoader = featureLoader
	}
	
	// MARK: - Setup Data
	
	private func loadFeatures() {
		let features = featureLoader.getFeatures()
		let promoFeatures = features
			.filter { $0.featureType == .promo }
			.compactMap { mapFeatureToAdapter($0).asAnyHashable() }
		let atomsFeatures = features
			.filter { $0.featureType == .atom }
			.compactMap { mapFeatureToAdapter($0).asAnyHashable() }
		let moleculesFeatures = features
			.filter { $0.featureType == .molecule }
			.compactMap { mapFeatureToAdapter($0).asAnyHashable() }
		
//		let result: [Section<AnyHashable>] = [
//			Section(name: "New", items: promoFeatures, isClosed: promoFeatures.isEmpty),
//			Section(name: "Short", items: atomsFeatures, isClosed: atomsFeatures.isEmpty),
//			Section(name: "New", items: moleculesFeatures, isClosed: moleculesFeatures.isEmpty)
//		]
		
		let result = [
			Section(name: "New", items: [
				FeatureAdapterCellModel(name: "Sensor", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				FeatureAdapterCellModel(name: "Tensor", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				FeatureAdapterCellModel(name: "Photo", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				FeatureAdapterCellModel(name: "Credit", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
			], isClosed: false),
			
			Section(name: "New", items: [
				SquareFeatureAdapterCellModel(name: "Eraser", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				SquareFeatureAdapterCellModel(name: "Dummy", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				SquareFeatureAdapterCellModel(name: "JSON", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				SquareFeatureAdapterCellModel(name: "AR", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				SquareFeatureAdapterCellModel(name: "Checker", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				SquareFeatureAdapterCellModel(name: "Checker", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				SquareFeatureAdapterCellModel(name: "Checker", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!
			], isClosed: false),
			
			Section(name: "New", items: [
				FeatureAdapterCellModel(name: "Glitch", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				FeatureAdapterCellModel(name: "Justify", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				FeatureAdapterCellModel(name: "Algo", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!,
				FeatureAdapterCellModel(name: "Redunant", image: UIImage(named: "retainCycle")!, id: UUID().uuidString, action: nil).asAnyHashable()!
			], isClosed: false)
		]
		
		self.features.onNext(result)
	}
	
	private func mapFeatureToAdapter(_ feature: FeatureProtocol) -> FeatureAdapterCellModel {
		let action: () -> Void = { [weak feature] in
			feature?.start(params: nil)
		}
		return FeatureAdapterCellModel(name: feature.name,
									   image: feature.image ?? UIImage(),
									   id: feature.identifier,
									   action: action)
	}
}

