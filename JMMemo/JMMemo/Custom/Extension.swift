//
//  Extension.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit

extension UIButton {
    
    func makeFloatingButton() {
        self.backgroundColor = .red
        self.layer.opacity = 0.8
        self.layer.cornerRadius = 30
    }
    
    func setImage(systemName: String) {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFit
        
        setImage(UIImage(systemName: systemName), for: .normal)
    }
    
    func resizeImage(image : UIImage, width : Float, height : Float) -> UIImage {
        let cgWidth = CGFloat(width)
        let cgHeight = CGFloat(height)
        
        // Begine Context
        UIGraphicsBeginImageContext(CGSize(width: cgWidth, height: cgHeight))
        // Get Current Context
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x : 0.0, y : cgHeight)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(image.cgImage!, in: CGRect(x: 0.0, y: 0.0, width: cgWidth, height: cgHeight))
        let scaledImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        // End Context
        UIGraphicsEndImageContext()
        
        if (scaledImage != nil) {
            scaledImage?.withTintColor(.white)
            return scaledImage!
        }
        return UIImage()
    }
    
}
