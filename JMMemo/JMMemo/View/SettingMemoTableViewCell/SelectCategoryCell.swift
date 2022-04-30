//
//  SelectCategoryCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/30.
//

import UIKit

class SelectCategoryCell: UITableViewCell {
    
    static let identifier = "SelectCategoryCell"
    
    // MARK: - Properties
    private var currentCategoryLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private var currentStatus: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .label
        
        return imageView
    }()
    
    public var isOpen: Bool = false {
        willSet {
            if isOpen {
                currentStatus.image = UIImage(systemName: "chevron.down")
            } else {
                currentStatus.image = UIImage(systemName: "chevron.right")
            }
        }
    }
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [currentCategoryLabel, currentStatus].forEach {
            contentView.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        currentCategoryLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(currentStatus.snp.leading).offset(-10)
        }
        
        currentStatus.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Method
    public func configure(_ isOpen: Bool, currentCategory: String) {
        self.isOpen = isOpen
        currentCategoryLabel.text = currentCategory
    }
}
