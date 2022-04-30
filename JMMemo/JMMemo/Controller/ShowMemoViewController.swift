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
        scrollView.backgroundColor = .white
        scrollView.layer.borderColor = UIColor.systemGray5.cgColor
        scrollView.layer.cornerRadius = 8
        scrollView.layer.borderWidth = 1
        
        return scrollView
    }()
    
    let memoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        
        [titleLabel, dateLabel, scrollView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(memoLabel)
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
    }
    
    // MARK: - Method
    private func configureNavBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모목록"
        navigationItem.title = "메모"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(title: "수정", style: .plain, target: self, action: nil)
        ]
    }
    
    public func configure(memo: MemoViewModel) {
        memoLabel.text = memo.memo
        titleLabel.text = memo.title
        dateLabel.text = memo.date
    }
    
}
