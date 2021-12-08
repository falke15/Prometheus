//
//  CALayer+Shadow.swift
//  Prometheus
//
//  Created by Pyretttt on 18.10.2021.
//

import UIKit

extension CALayer {
	public enum ShadowStyle {
		case transparent
		case dark
		
		var color: CGColor {
			switch self {
			case .transparent:
				return Pallete.Black.black4.cgColor
			case .dark:
				return Pallete.Black.black2.cgColor
			}
		}
		
		var offset: CGSize {
			switch self {
			case .transparent:
				return CGSize(width: 1, height: 2)
			case .dark:
				return CGSize(width: 0, height: 0)
			}
		}
		
		var visualParameteres: (radius: CGFloat, opacity: Float) {
			switch self {
			case .transparent:
				return (radius: 6, opacity: 0.15)
			case .dark:
				return (radius: 7.5, opacity: 0.75)
			}
		}
	}
	
	public func applyShadows(style: ShadowStyle) {
		self.shadowColor = style.color
		self.shadowOffset = style.offset
		self.shadowRadius = style.visualParameteres.radius
		self.shadowOpacity = style.visualParameteres.opacity
	}
}
