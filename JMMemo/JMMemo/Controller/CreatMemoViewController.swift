//
//  CreatMemoViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/29.
//

import UIKit

class CreatMemoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.makeFloatingButton()
        
        return button
    }()
    
    private let buttonImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "gearshape.fill"))
        image.tintColor = .white
        
        return image
    }()
    
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "제목"
        
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        tf.autocapitalizationType = .sentences
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.returnKeyType = .done
        
        return tf
    }()
    
    private let memoTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray5.cgColor
        tv.layer.cornerRadius = 8
        
        tv.font = .systemFont(ofSize: 14, weight: .regular)
        tv.autocapitalizationType = .sentences
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.returnKeyType = .default
        
        return tv
    }()
    
    private let memoStrCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "0"
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "2022년 4월 29일 오후 4:26"
        
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavBar()
        keyboardWillShow()
        hideKeyboard()
        
        [titleTextField, memoTextView, memoStrCountLabel, dateLabel ,floatingButton].forEach {
            view.addSubview($0)
        }
        floatingButton.addSubview(buttonImage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNoti()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleTextField.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
//            $0.top.equalToSuperview().offset(116)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        memoStrCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(titleTextField.snp.trailing).offset(-5)
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.bottom.equalTo(memoTextView.snp.top).offset(-3)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(titleTextField.snp.leading).offset(5)
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.bottom.equalTo(memoTextView.snp.top).offset(-3)
        }
        
        memoTextView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-65)
        }
        
        buttonImage.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Method
    private func configureNavBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모목록"
        navigationItem.title = "메모작성"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func keyboardWillShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowChangeConstraint(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideChangeConstraint(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNoti() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShowChangeConstraint(_ sender: Notification) {
        var keyboardHeight: CGFloat = 0
        
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        updateConstraints(keyboardHeight)
    }
    
    @objc func keyboardWillHideChangeConstraint(_ sender: Notification) {
        print("keyboardHide")
        updateConstraints(0)
    }
    
    func updateConstraints(_ height: CGFloat) {
        memoTextView.snp.remakeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset((-height - 40))
            print("update Con")
        }
        
        floatingButton.snp.remakeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset((-height - 65))
        }
        print("함수호출")
    }
}
