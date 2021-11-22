//
//  VideoPlayer+Extensions.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 15.11.2021.
//

import Foundation

// MARK: - Supplementaries

extension VideoPlayerView {
	public enum Configuration {
		case base
		
		var primaryColor: UIColor {
			Pallete.Black.black4
		}
		
		var gradientColors: [CGColor] {
			[Pallete.Light.white1.withAlphaComponent(0.3).cgColor,
			 Pallete.Utility.transparent.cgColor,
			 Pallete.Utility.transparent.cgColor,
			 Pallete.Light.white1.withAlphaComponent(0.3).cgColor]
		}
		
		var timeFormatter: NumberFormatter {
			let formatter = NumberFormatter()
			formatter.minimumIntegerDigits = 2
			formatter.minimumFractionDigits = 0
			formatter.roundingMode = .down
			
			return formatter
		}
	}
}
