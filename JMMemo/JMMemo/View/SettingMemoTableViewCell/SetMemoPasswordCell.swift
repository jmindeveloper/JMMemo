//
//  SetMemoPasswordCell.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/30.
//

import UIKit

class SetMemoPasswordCell: UITableViewCell {
    
    static let identifier = "SetMemoPasswordCell"
    
    // MARK: - Properties
    private let memoManeger = MemoRealmManeger()
    
    public var memo: Memo? = nil {
        willSet { toggle.isOn = newValue?.isSecret ?? false }
    }
    public var isEditMode = false
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "비밀메모"
        
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
            let alert = UIAlertController(title: nil, message: "비밀번호를 설정해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                guard let self = self else { return }
                guard let password = alert.textFields?[0].text else {
                    self.deletePassword(sender)
                    return
                }
                
                if password.isEmpty {
                    self.deletePassword(sender)
                } else {
                    if !self.isEditMode {
                        self.memo?.isSecret = true
                        self.memo?.password = Int(password)!
                    } else {
                        let query = UpdateMemoQuery.password
                        let query2 = UpdateMemoQuery.isSecret
                        
                        self.memoManeger.updateMemo(memo: self.memo, query: query2, data: true)
                        self.memoManeger.updateMemo(memo: self.memo, query: query, data: Int(password)!)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
                guard let self = self else { return }
                self.deletePassword(sender)
            }
            alert.addTextField { tf in
                tf.placeholder = "Password"
                tf.textContentType = .creditCardNumber
                tf.isSecureTextEntry = true
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            parentViewController?.present(alert, animated: true)
        } else {
            self.deletePassword(sender)
        }
    }
    
    private func deletePassword(_ sender: UISwitch) {
        if !isEditMode {
            self.memo?.password = nil
            self.memo?.isSecret = false
        } else {
            let query = UpdateMemoQuery.password
            let query2 = UpdateMemoQuery.isSecret
            
            memoManeger.updateMemo(memo: memo, query: query2, data: false)
            memoManeger.updateMemo(memo: memo, query: query, data: nil)
        }
        sender.isOn = false
    }
}
