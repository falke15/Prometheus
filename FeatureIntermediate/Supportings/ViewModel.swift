//
//  ViewModel.swift
//  Prometheus
//
//  Created by Pyretttt on 28.09.2021.
//

import Foundation

/// Вспомогательная обертка над вьюмоделью, которую биндится единожды
public protocol ViewModelType: AnyObject {
	associatedtype Input
	associatedtype Output
	
	func transform(input: Input) -> Output
}
