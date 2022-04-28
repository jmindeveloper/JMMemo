//
//  UserAddCategoryCollectionViewCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit

class UserAddCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserAddCategoryCollectionViewCell"
    
    // MARK: - Properties
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        
        [categoryNameLabel, countLabel].forEach {
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
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalTo(countLabel.snp.leading).offset(-15)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-25)
        }
    }
    
    // MARK: - Method
    private func configureCell() {
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.backgroundColor = .systemGray6
    }
    
    public func configure(with model: CategoryViewModel) {
        categoryNameLabel.text = model.categoryName
        countLabel.text = model.count
    }
}
