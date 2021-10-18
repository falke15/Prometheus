//
//  CALayer+Shadow.swift
//  Prometheus
//
//  Created by Pyretttt on 18.10.2021.
//

import UIKit

// MARK: - Shadows

extension CALayer {
	public enum ShadowStyle {
		case transparent
		
		var color: CGColor {
			return Pallete.Black.black4.cgColor
		}
		
		var offset: CGSize {
			return CGSize(width: 2, height: 2)
		}
		
		var visualParameteres: (radius: CGFloat, opacity: Float) {
			return (radius: 4.5, opacity: 0.12)
		}
	}
	
	public func applyShadows(style: ShadowStyle) {
		self.shadowColor = style.color
		self.shadowOffset = style.offset
		self.shadowRadius = style.visualParameteres.radius
		self.shadowOpacity = style.visualParameteres.opacity
	}
}
