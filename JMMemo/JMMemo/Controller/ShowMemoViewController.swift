//
//  ShowMemoViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/30.
//

import UIKit
import RealmSwift

class ShowMemoViewController: UIViewController {
    
    // MARK: - Properties
    private var isFloatingShow = false
    private var currentMemo: Memo?
    private let memoManeger = MemoRealmManeger()
    weak var delegate: CreatMemoViewControllerDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.layer.borderColor = UIColor.systemGray5.cgColor
        scrollView.layer.cornerRadius = 8
        scrollView.layer.borderWidth = 1
        scrollView.backgroundColor = .systemBackground
        
        return scrollView
    }()
    
    let memoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.makeFloatingButton()
        
        return button
    }()
    
    private let floatingButtonImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "gearshape.fill"))
        image.tintColor = .white
        
        return image
    }()
    
    private let editMemoButton: UIButton = {
        let button = UIButton()
        button.makeFloatingButton()
        
        return button
    }()
    
    private let editMenuButtonImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "pencil"))
        image.tintColor = .white
        
        return image
    }()
    
    private let setPasswordButton: UIButton = {
        let button = UIButton()
        button.makeFloatingButton()
        
        return button
    }()
    
    private let setPasswordButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "lock.fill"))
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.makeFloatingButton()
        
        return button
    }()
    
    private let starButtonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star"))
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private let floatingStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        
        return stackView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        
        [titleLabel, dateLabel, scrollView, floatingStack].forEach {
            view.addSubview($0)
        }
        
        [starButton, setPasswordButton, editMemoButton, floatingButton].forEach {
            floatingStack.addArrangedSubview($0)
            if $0 != floatingButton {
                $0.isHidden = true
            }
        }
        
        floatingButton.addSubview(floatingButtonImage)
        editMemoButton.addSubview(editMenuButtonImage)
        setPasswordButton.addSubview(setPasswordButtonImage)
        starButton.addSubview(starButtonImage)
        
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton(_:)), for: .touchUpInside)
        editMemoButton.addTarget(self, action: #selector(didTapeditMemoButton(_:)), for: .touchUpInside)
        setPasswordButton.addTarget(self, action: #selector(didTapsetPasswordButton(_:)), for: .touchUpInside)
        starButton.addTarget(self, action: #selector(didTapstarButton(_:)), for: .touchUpInside)
        
        scrollView.addSubview(memoLabel)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        delegate?.reloadMemoData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(3)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        memoLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
            $0.width.equalToSuperview().offset(-20)
        }
        
        floatingStack.snp.makeConstraints {
            $0.width.equalTo(60)
//            $0.height.equalTo(300)
            $0.trailing.equalToSuperview().offset(-30)
            $0.bottom.equalToSuperview().offset(-65)
        }
        
        [floatingButton, editMemoButton, setPasswordButton, starButton].forEach {
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
        }
        
        [floatingButtonImage, editMenuButtonImage, setPasswordButtonImage, starButtonImage].forEach {
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(30)
                make.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    // MARK: - Method
    private func configureNavBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모목록"
        navigationItem.title = "메모"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareMemo(_:)))
        ]
    }
    
    public func configure(memo: Memo?) {
        
        guard let memo = memo else { return }
        currentMemo = memo
        memoLabel.text = memo.memo
        titleLabel.text = memo.memoTitle
        var date = memo.memoDate
        date.removeLast()
        date.removeLast()
        dateLabel.text = date
        
        if memo.star {
            starButtonImage.image = UIImage(systemName: "star.fill")
        } else {
            starButtonImage.image = UIImage(systemName: "star")
        }
        
        if memo.isSecret {
            setPasswordButtonImage.image = UIImage(systemName: "lock.fill")
        } else {
            setPasswordButtonImage.image = UIImage(systemName: "lock.open")
        }
    }
    
    @objc func shareMemo(_ sender: UIBarButtonItem) {
        let memo: [Any] = [memoLabel.text ?? ""]
        let memoViewController = UIActivityViewController(activityItems: memo, applicationActivities: nil)
        self.present(memoViewController, animated: true)
    }
    
    @objc func didTapFloatingButton(_ sender: UIButton) {
        let buttons = [starButton, setPasswordButton, editMemoButton]
        isFloatingShow.toggle()
        if isFloatingShow {
            buttons.forEach { [weak self] button in
                guard let self = self else { return }
                button.isHidden = false
                button.alpha = 0
                
                UIView.animate(withDuration: 0.3) {
                    button.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            buttons.reversed().forEach { button in
                UIView.animate(withDuration: 0.3) {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                }
            }
        }
        
    }
    
    @objc func didTapeditMemoButton(_ sender: UIButton) {
        let vc = CreatMemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapsetPasswordButton(_ sender: UIButton) {
        guard let memo = currentMemo else { return }
        
        func wrongAlert() {
            let alert = UIAlertController(title: nil, message: "비밀번호가 잘못됐습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        if memo.isSecret {
            let alert = UIAlertController(title: nil, message: "비밀번호를 해제하실려면 비밀번호를 입력해 주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                guard let self = self else { return }
                guard let password = Int(alert.textFields?[0].text ?? "") else {
                    wrongAlert()
                    return
                }
                
                if memo.password == password {
                    let query = UpdateMemoQuery.isSecret
                    let query2 = UpdateMemoQuery.password
                    self.memoManeger.updateMemo(memo: memo, query: query, data: false)
                    self.memoManeger.updateMemo(memo: memo, query: query2, data: nil)
                    self.setPasswordButtonImage.image = UIImage(systemName: "lock.open")
                } else {
                    wrongAlert()
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addTextField { tf in
                tf.placeholder = "Password"
                tf.textContentType = .creditCardNumber
                tf.isSecureTextEntry = true
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: nil, message: "비밀번호를 설정하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                guard let self = self else { return }
                guard let password = Int(alert.textFields?[0].text ?? "") else { return }
                
                let query = UpdateMemoQuery.isSecret
                let query2 = UpdateMemoQuery.password
                
                self.memoManeger.updateMemo(memo: memo, query: query, data: true)
                self.memoManeger.updateMemo(memo: memo, query: query2, data: password)
                self.setPasswordButtonImage.image = UIImage(systemName: "lock.fill")
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addTextField { tf in
                tf.placeholder = "Password"
                tf.textContentType = .creditCardNumber
                tf.isSecureTextEntry = true
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func didTapstarButton(_ sender: UIButton) {
        guard let memo = currentMemo else { return }
        let query = UpdateMemoQuery.star
        if memo.star {
            memoManeger.updateMemo(memo: memo, query: query, data: false)
            starButtonImage.image = UIImage(systemName: "star")
        } else {
            memoManeger.updateMemo(memo: memo, query: query, data: true)
            starButtonImage.image = UIImage(systemName: "star.fill")
        }
    }
}
