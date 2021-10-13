//
//  AggregationServicesFactory.swift
//  Prometheus
//
//  Created by Pyretttt on 10.10.2021.
//

import Foundation
import FeatureIntermediate

protocol AggregationServiceLocatorType {
	var featureLoader: FeatureLoader { get }
	
}

final class AggregationServicesLocator: AggregationServiceLocatorType {
	private(set) lazy var featureLoader: FeatureLoader = FeatureLoader()

	
}
