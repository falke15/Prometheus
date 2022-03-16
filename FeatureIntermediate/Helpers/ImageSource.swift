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
	case play
	case pause
	case dead
	case ic24_dotsVertical
	case ic24_fullScreen
	case ic24_dotsHorizontal
	case ic24_redCircle
    case ic64_up_and_down_arrows
}

public extension ImageSource {
	var image: UIImage {
		guard let image = UIImage(named: self.rawValue) else {
			return UIImage.gradientImage(colors: UIImage.grayGradientColors)
		}
		
		return image.withRenderingMode(.alwaysTemplate)
	}
}
