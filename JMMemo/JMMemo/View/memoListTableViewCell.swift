//
//  memoListTableViewCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit
import SnapKit

class memoListTableViewCell: UITableViewCell {
    
    static let identifier = "memoListTableViewCell"
    
    // MARK: - Properties
    private let memoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .gray
        
        return label
    }()
    
    private let lockImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "lock.fill")
        imageView.image = image
        imageView.tintColor = .systemGray2
        
        return imageView
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [memoTitleLabel, dateLabel, lockImage].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lockImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(25)
        }
        
        memoTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(memoTitleLabel.snp.leading).offset(5)
            $0.top.equalTo(memoTitleLabel.snp.bottom).offset(3)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - Method
    public func configure(with memo: Memo) {
        memoTitleLabel.text = memo.memoTitle
        dateLabel.text = memo.memoDate
        
        if memo.isSecret {
            lockImage.isHidden = false
            memoTitleLabel.text = "Top Secret"
            dateLabel.text = "Top Secret"
        } else {
            lockImage.isHidden = true
            memoTitleLabel.text = memo.memoTitle
            dateLabel.text = memo.memoDate
        }
    }
    
}
