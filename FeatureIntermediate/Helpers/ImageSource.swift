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
	
	public var image: UIImage {
		guard let image = UIImage(named: self.rawValue) else {
			fatalError("Отсутствует ресурс: \(self.rawValue)")
		}
		
		return image.withRenderingMode(.alwaysTemplate)
	}
}
