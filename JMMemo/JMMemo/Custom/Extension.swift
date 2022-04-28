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
        self.layer.cornerRadius = 30
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
