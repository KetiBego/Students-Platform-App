//
//  ImageWrapper.swift
//  MyAssetBook
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit

public struct ImageWrapper {
    private let name: String
    
    public init(name: String) { self.name = name }
    
    // UIImage  of selected image
    public var image: UIImage {
        return UIImage(systemName: name)!
    }

    // UIImage with template rendering mode
    public var template: UIImage {
        return image.withRenderingMode(.alwaysTemplate)
    }
}

public extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
