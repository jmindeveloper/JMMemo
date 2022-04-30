//
//  SearchResultViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/30.
//

import UIKit
import RealmSwift

class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    public var memos: Results<Memo>? = nil {
        willSet { searchResultTableView.reloadData() }
    }
    
    public let searchResultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(memoListTableViewCell.self, forCellReuseIdentifier: memoListTableViewCell.identifier)
        
        return tableView
    }()
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        
        view.addSubview(searchResultTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    // MARK: - Method
    private func checkPassword(_ rightPassword: Int, completion: @escaping () -> ()) {
        
        func wrongAlert() {
            let alert = UIAlertController(title: nil, message: "비밀번호가 잘못됐습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        let alert = UIAlertController(title: nil, message: "비밀번호를 입력해주세요", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let password = Int(alert.textFields?[0].text ?? "") else {
                wrongAlert()
                return
            }
            
            if rightPassword == password {
                completion()
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
        
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: memoListTableViewCell.identifier, for: indexPath) as? memoListTableViewCell else { return UITableViewCell() }
        
        guard let memos = memos else { return UITableViewCell() }
        
        cell.configure(with: memos[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShowMemoViewController()
        
        guard let memos = memos else { return }
        
        // 비밀번호 확인
        if memos[indexPath.row].isSecret {
            checkPassword(memos[indexPath.row].password!) { [weak self] in
                guard let self = self else { return }
                let title = memos[indexPath.row].memoTitle
                let memo = memos[indexPath.row].memo
                let date = memos[indexPath.row].memoDate
                let viewModel = MemoViewModel(title: title, memo: memo, date: date)
                vc.configure(memo: viewModel)
                
                self.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        
        let title = memos[indexPath.row].memoTitle
        let memo = memos[indexPath.row].memo
        let date = memos[indexPath.row].memoDate
        let viewModel = MemoViewModel(title: title, memo: memo, date: date)
        vc.configure(memo: viewModel)
        
        self.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
