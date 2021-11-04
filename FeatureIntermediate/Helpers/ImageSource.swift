//
//  ImageSource.swift
//  exKeeper
//
//  Created by Pyretttt on 04.09.2021.
//

import UIKit

public enum ImageSource: String {
	case biometry
	case remove
	case gradient
	case arrowDown
	
	public var image: UIImage {
		guard let image = UIImage(named: self.rawValue) else {
			return UIImage.grayGradient
		}
		
		return image.withRenderingMode(.alwaysTemplate)
	}
}

public extension UIImage {
	static func makeImage(color: UIColor,
						  size: CGSize = CGSize(width: 256, height: 256)) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: CGRect(origin: .zero, size: size))
		let image = renderer.image { context in
			context.cgContext.setFillColor(color.cgColor)
			context.cgContext.fill(context.format.bounds)
		}
		return image
	}
	
	static let grayGradient = gradientImage(colors: [Pallete.Light.white1, Pallete.Black.black1])
	
	static func gradientImage(colors: [UIColor],
							  size: CGSize = CGSize(width: 256, height: 256)) -> UIImage {
		let gradient = CAGradientLayer()
		gradient.bounds = CGRect(origin: .zero, size: size)
		gradient.colors = colors.map { $0.cgColor }
		gradient.startPoint = .zero
		gradient.endPoint = CGPoint(x: 1, y: 1)
		
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		if let context = UIGraphicsGetCurrentContext() {
			gradient.render(in: context)
		}
		if let image = UIGraphicsGetCurrentContext()?.makeImage() {
			UIGraphicsEndImageContext()
			return UIImage(cgImage: image)
		}
		UIGraphicsEndImageContext()
		fatalError("Can't render image in context")
	}
}
