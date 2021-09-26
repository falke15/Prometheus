//
//  ImageSource.swift
//  exKeeper
//
//  Created by Pyretttt on 04.09.2021.
//

import UIKit

enum ImageSource: String {
	case biometry
	case remove
	
	var image: UIImage {
		guard let image = UIImage(named: self.rawValue) else {
			fatalError("Отсутствует ресурс: \(self.rawValue)")
		}
		
		return image
	}
}
