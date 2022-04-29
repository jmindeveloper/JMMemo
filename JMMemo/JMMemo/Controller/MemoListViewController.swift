//
//  MemoListViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit
import SnapKit
import RealmSwift

class MemoListViewController: UIViewController {
    
    // MARK: - Properties
    private let memoListTableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(memoListTableViewCell.self, forCellReuseIdentifier: memoListTableViewCell.identifier)
        
        return tableView
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.makeFloatingButton()
        
        return button
    }()
    
    private let buttonImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus"))
        image.tintColor = .white
        
        return image
    }()
    
    public var navigationTitle = "Memo"
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        
        memoListTableView.dataSource = self
        memoListTableView.delegate = self
        memoListTableView.rowHeight = 60
        
        view.addSubview(memoListTableView)
        view.addSubview(floatingButton)
        floatingButton.addSubview(buttonImage)
        
        // button target
        floatingButton.addTarget(self, action: #selector(didFloatingButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        memoListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        navigationItem.title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc func didFloatingButtonTapped(_ sender: UIButton) {
        let vc = CreatMemoViewController()
        if let category = navigationItem.title, category != "전체", category != "즐겨찾기", category != "Memo" {
            vc.category = category
        } else {
            vc.category = ""
        }
        vc.newMemo = Memo()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MemoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dummyMemoList.count
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: memoListTableViewCell.identifier, for: indexPath) as? memoListTableViewCell else { return UITableViewCell() }
//        cell.configure(with: dummyMemoList[indexPath.row])
        
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension MemoListViewController: UITableViewDelegate {
    
}
