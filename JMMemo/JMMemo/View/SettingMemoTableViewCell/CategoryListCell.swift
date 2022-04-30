//
//  CategoryListCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/30.
//

import UIKit
import SwiftUI

class CategoryListCell: UITableViewCell {
    
    static let identifier = "CategoryListCell"
    
    // MARK: - Properties
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let checkMark: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [categoryNameLabel, checkMark].forEach {
            contentView.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalTo(checkMark.snp.leading).offset(-10)
        }
        
        checkMark.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Method
    func configure(_ categoryName: String, isSelected: Bool) {
        if isSelected {
            checkMark.isHidden = false
        } else {
            checkMark.isHidden = true
        }
        categoryNameLabel.text = categoryName
    }
    
}
