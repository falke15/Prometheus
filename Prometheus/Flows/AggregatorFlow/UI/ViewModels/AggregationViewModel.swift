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
	 	var items: Observable<[FeatureProtocol]>
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
	
	private let features = PublishSubject<[FeatureProtocol]>()
	
	// MARK: - Lifecycle
	
	init(featureLoader: FeatureLoader) {
		self.featureLoader = featureLoader
	}
	
	// MARK: - Setup Data
	
	private func loadFeatures() {
		let feature = featureLoader.getFeatures()
		features.onNext(feature)
	}
}
