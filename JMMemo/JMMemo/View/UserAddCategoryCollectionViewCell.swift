//
//  UserAddCategoryCollectionViewCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit
import SnapKit

protocol UserAddCategoryCollectionViewCellDelegate: AnyObject {
    func delete(_ sender: UIButton)
}

class UserAddCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserAddCategoryCollectionViewCell"
    
    // MARK: - Properties
    public var CellDeleteMode = false
    weak var delegate: UserAddCategoryCollectionViewCellDelegate?
    
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
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private let deleteButtonImage: UIImageView = {
        let image = UIImage(systemName: "x.circle")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .red
        
        return imageView
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        
        [categoryNameLabel, countLabel, deleteButton].forEach {
            contentView.addSubview($0)
        }
        deleteButton.addSubview(deleteButtonImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        categoryNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalTo(countLabel.snp.leading).offset(-15)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-25)
            $0.width.height.equalTo(40)
        }
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        
        deleteButtonImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        countLabel.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-25)
        }
        
        categoryNameLabel.text = model.categoryName
        countLabel.text = model.count
    }
    
    func deleteMode(_ isActive: Bool) {
        if isActive {
            deleteButton.isHidden = false
            countLabel.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(-65)
                $0.centerY.equalToSuperview()
            }
        } else {
            deleteButton.isHidden = true
            countLabel.snp.remakeConstraints {
                $0.trailing.equalToSuperview().offset(-25)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    @objc func didTapDeleteButton(_ sender: UIButton) {
        delegate?.delete(sender)
    }
}
