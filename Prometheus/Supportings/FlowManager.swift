//
//  FlowManager.swift
//  exKeeper
//
//  Created by Pyretttt on 20.09.2021.
//

import Foundation

/// Менеджер композитных флоу
protocol FlowManager {
	associatedtype ScenarioChain
	
	/// Шаги флоу
	var steps: [ScenarioChain] { get }
	
	/// Перейти на след этап флоу
	func next()
	
	/// Вернуться на предыдущий шаг
	func undo()
	
	/// Перейти к заданному шагу
	/// - Parameter to: Сценарий для перехода
	func forceTransition(to: ScenarioChain)
}
