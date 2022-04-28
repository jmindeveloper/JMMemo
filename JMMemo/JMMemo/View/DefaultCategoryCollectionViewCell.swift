//
//  DefaultCategoryCollectionViewCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit

class DefaultCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DefaultCategoryCollectionViewCell"
    
    // MARK: - Properties
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    private let categoryImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .bold)
        
        return label
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        
        [categoryImage, categoryNameLabel, countLabel].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryImage.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        categoryNameLabel.snp.makeConstraints {
            $0.centerX.equalTo(categoryImage.snp.centerX)
            $0.top.equalTo(categoryImage.snp.bottom).offset(7)
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    // MARK: - Method
    public func configure() {
        categoryImage.image = UIImage(systemName: "note.text")
        categoryNameLabel.text = "전체"
        countLabel.text = "5"
    }
    
    private func configureCell() {
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.backgroundColor = .systemGray6
    }
}
