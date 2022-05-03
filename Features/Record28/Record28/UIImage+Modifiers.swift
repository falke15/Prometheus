//
//  UIImage+Modifiers.swift
//  Record28
//
//  Created by pyretttt pyretttt on 20.03.2022.
//

import UIKit

extension UIImage {
    static func addBackgroundColor(to image: UIImage?, backgroundColor: UIColor?) -> UIImage? {
        guard let image = image ,
              let cgImage = image.cgImage,
              let color = backgroundColor?.cgColor else { return nil }
        
        UIGraphicsBeginImageContext(image.size)
        let rect = CGRect(origin: .zero, size: image.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: 0, y: image.size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        context.setFillColor(color)
        context.fill(rect)
        context.draw(cgImage, in: rect)
        
        let appliedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return appliedImage
    }
    
        
    func resizedImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    static func convertToGrayScale(image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        let imageRect: CGRect = CGRect(origin: CGPoint.zero,
                                       size: CGSize(width: image.size.width, height:  image.size.height))
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        if let cgImg = image.cgImage {
            context?.draw(cgImg, in: imageRect)
            if let makeImg = context?.makeImage() {
                let imageRef = makeImg
                let newImage = UIImage(cgImage: imageRef)
                return newImage
            }
        }
        
        return nil
    }
}
