//
//  ClosedRange+Shift.swift
//  RetainCycle
//
//  Created by Pyretttt on 24.12.2021.
//

import Foundation

extension ClosedRange where Bound == Int {
	func shifted(_ shiftFactor: Int) -> Self {
		let lower = lowerBound + shiftFactor
		let upper = upperBound + shiftFactor
		
		return lower...upper
	}
}
