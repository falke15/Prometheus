//
//  LinearChartView+Mock.swift
//  RetainCycle
//
//  Created by pyretttt pyretttt on 10.01.2022.
//

import CoreGraphics
import Combine

extension LinearChartView {
    static var mock: [OrdinatePoint] {
        var result: [OrdinatePoint] = []
        
        var random: Int
        var range: ClosedRange<Int>
        
        while result.count < 500 {
            random = Int.random(in: 500...750)
            range = (random - 30)...(random + 30)
            for _ in 1...25 {
                result.append(OrdinatePoint(absoluteY: CGFloat(Int.random(in: range))))
            }
        }
        
        return result
    }
}
