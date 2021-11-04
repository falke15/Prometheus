//
//  UINavigationBar+Styles.swift
//  FeatureIntermediate
//
//  Created by Pyretttt on 22.10.2021.
//

import UIKit

public extension UINavigationBar {
	enum Style {
		case standard
		case transparent
		case customColor(color: UIColor)
		
		var backgroundColor: UIColor {
			switch self {
			case .standard:
				return Pallete.Gray.gray1
			case .transparent:
				return Pallete.Utility.transparent
			case let .customColor(color: color):
				return color
			}
		}
		
		var titleAttributes: [NSAttributedString.Key: Any]? {
			let defaultAttributes: [NSAttributedString.Key: Any] = [
				.font: TextFont.base.withSize(NumericValues.xLarge),
				.foregroundColor: Pallete.Black.black3
			]
			switch self {
			case .standard:
				return defaultAttributes
			case .transparent:
				return defaultAttributes
			case .customColor:
				return defaultAttributes
			}
		}
		
		var tintColor: UIColor {
			switch self {
			case .standard:
				return Pallete.Light.white1
			case .transparent:
				return Pallete.Light.white1
			case .customColor:
				return Pallete.Light.white1
			}
		}
	}
	
	func applyStyle(_ style: Style) {
		backgroundColor = style.backgroundColor
		barTintColor = style.backgroundColor
		isTranslucent = style.backgroundColor == Pallete.Utility.transparent
		titleTextAttributes = style.titleAttributes
		largeTitleTextAttributes = style.titleAttributes
		tintColor = style.tintColor
		
		setBackgroundImage(UIImage(), for: .default)
		shadowImage = UIImage()
	}
}
