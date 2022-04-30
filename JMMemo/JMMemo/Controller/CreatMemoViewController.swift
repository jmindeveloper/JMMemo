//
//  CreatMemoViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/29.
//

import UIKit

class CreatMemoViewController: UIViewController {
    
    // MARK: - Properties
    
    public var newMemo: Memo?
    public var category = ""
    private let memoManeger = MemoRealmManeger()
    
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
        keyboardNoti()
        hideKeyboard()
        settingNewMemo()
        
        dateLabel.text = creatMemoTime()
        
        memoTextView.delegate = self
        
        [titleTextField, memoTextView, memoStrCountLabel, dateLabel ,floatingButton].forEach {
            view.addSubview($0)
        }
        floatingButton.addSubview(buttonImage)
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton(_:)), for: .touchUpInside)
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
    private func settingNewMemo() {
        newMemo?.category = category
        newMemo?.isSecret = false
        newMemo?.star = false
        newMemo?.memoDate = creatMemoTime()
    }
    
    private func creatMemoTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 dd일 a h:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let dateStr = dateFormatter.string(from: Date())
        return dateStr
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모목록"
        navigationItem.title = "메모작성"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveMemo))
        ]
    }
    
    private func keyboardNoti() {
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
        updateConstraints(0)
    }
    
    func updateConstraints(_ height: CGFloat) {
        memoTextView.snp.remakeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset((-height - 40))
        }
        
        floatingButton.snp.remakeConstraints {
            $0.width.height.equalTo(60)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset((-height - 65))
        }
    }
    
    @objc func didTapFloatingButton(_ sender: UIButton) {
        let vc = SettingMemoViewController()
        vc.newMemo = newMemo
        vc.configure(category: newMemo?.category ?? "Category")
        view.endEditing(true)
        
        self.present(vc, animated: true)
    }
    
    @objc func saveMemo() {
        func showAlert(_ q: String) {
            let alert = UIAlertController(title: nil, message: "\(q) 작성해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert("메모제목을")
            return
        }
        guard let memo = memoTextView.text, !memo.isEmpty else {
            showAlert("메모를")
            return
        }
        
        newMemo?.memo = memo
        newMemo?.memoTitle = title
        
        if newMemo != nil {
            memoManeger.saveMemo(with: newMemo!)
        }
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CreatMemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let strCount = memoTextView.text.count
        memoStrCountLabel.text = String(strCount)
    }
}
