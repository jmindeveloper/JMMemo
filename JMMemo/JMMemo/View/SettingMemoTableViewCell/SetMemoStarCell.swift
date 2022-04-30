//
//  SetMemoStarCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/30.
//

import UIKit

class SetMemoStarCell: UITableViewCell {
    
    static let identifier = "SetMemoStarCell"
    
    // MARK: - Properties
    public var memo: Memo?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        
        return label
    }()
    
    let toggle: UISwitch = {
        let toggle = UISwitch()
        
        return toggle
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [label, toggle].forEach {
            contentView.addSubview($0)
        }
        
        toggle.addTarget(self, action: #selector(toggleIsOn(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        toggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }

    }
    
    // MARK: - Method
    @objc func toggleIsOn(_ sender: UISwitch) {
        if sender.isOn {
            memo?.star = true
        } else {
            memo?.star = false
        }
    }
}
