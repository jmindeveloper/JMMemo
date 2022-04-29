//
//  SettingMemoViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/29.
//

import UIKit

class SettingMemoViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        configureNavBar()
    }
    
    // MARK: - Method
    private func configureNavBar() {
        navigationItem.title = "메모설정"
    }
}
