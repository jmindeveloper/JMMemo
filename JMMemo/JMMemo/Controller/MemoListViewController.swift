//
//  MemoListViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit
import SnapKit
import RealmSwift

protocol CategoryCollectionViewReload: AnyObject {
    func reloadCollectionView()
}

class MemoListViewController: UIViewController {
    
    // MARK: - Properties
    public var memos: Results<Memo>? = nil {
        willSet {
            memoListTableView.reloadData()
        }
    }
    private let memoManeger = MemoRealmManeger()
    weak var delegate: CategoryCollectionViewReload?
    
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
    
    private let SearchBar: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.placeholder = "Search for a Memo"
        
        controller.searchBar.autocapitalizationType = .sentences
        controller.searchBar.autocorrectionType = .no
        controller.searchBar.spellCheckingType = .no
        
        return controller
    }()
    
    public var navigationTitle = "Memo"
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        
        SearchBar.searchResultsUpdater = self
        memoListTableView.dataSource = self
        memoListTableView.delegate = self
        memoListTableView.rowHeight = 60
        
        view.addSubview(memoListTableView)
        view.addSubview(floatingButton)
        floatingButton.addSubview(buttonImage)
        
        // button target
        floatingButton.addTarget(self, action: #selector(didFloatingButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.reloadCollectionView()
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
    // ????????? ??????
    private func configureNavBar() {
        navigationItem.title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = SearchBar
    }
    
    // ??????????????? ??????????????? -> ????????????
    @objc func didFloatingButtonTapped(_ sender: UIButton) {
        let vc = CreatMemoViewController()
        if let category = navigationItem.title, category != "??????", category != "????????????", category != "Memo" {
            vc.category = category
        } else {
            vc.category = ""
        }
        vc.memoObject = Memo()
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // ???????????? ????????????
    private func checkPassword(_ rightPassword: Int, completion: @escaping () -> ()) {
        // ???????????? ???????????? ??????
        func wrongAlert() {
            let alert = UIAlertController(title: nil, message: "??????????????? ??????????????????", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "??????", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        
        let alert = UIAlertController(title: nil, message: "??????????????? ??????????????????", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "??????", style: .default) { _ in
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
        let cancelAction = UIAlertAction(title: "??????", style: .cancel)
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

// MARK: - UITableViewDataSource
extension MemoListViewController: UITableViewDataSource {
    // ??? ??????
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos?.count ?? 0
    }
    
    // ??? ??????
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: memoListTableViewCell.identifier, for: indexPath) as? memoListTableViewCell else { return UITableViewCell() }
        guard let memos = memos else { return UITableViewCell() }
        
        cell.configure(with: memos[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    // ????????????
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let deleteMemo = memos?[indexPath.row] else { return }
            
            memoManeger.deleteMemo(with: deleteMemo)
            memoListTableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension MemoListViewController: UITableViewDelegate {
    // ??? ???????????? -> ??????????????? ???????????? -> ??????????????? ??????
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShowMemoViewController()
        
        guard let memos = memos else { return }
        
        // ???????????? ??????
        if memos[indexPath.row].isSecret {
            checkPassword(memos[indexPath.row].password!) { [weak self] in
                guard let self = self else { return }
                
                let memo = memos[indexPath.row]
                vc.configure(memo: memo)
                
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        
        let memo = memos[indexPath.row]
        vc.delegate = self
        vc.configure(memo: memo)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemoListViewController: CreatMemoViewControllerDelegate {
    // ????????????????????? ??????????????? ???????????? ?????????
    func reloadMemoData() {
        let allMemo = memoManeger.getAllMemo()
        let filterStr = "category == '\(navigationItem.title ?? "")'"
        if navigationItem.title != "Memo", navigationItem.title != "??????", navigationItem.title != "????????????" {
            memos = memoManeger.filterMemo(with: allMemo, filterStr)
        } else if navigationItem.title == "????????????" {
            memos = memoManeger.filterMemo(with: allMemo, "star == true")
        } else {
            memos = memoManeger.getAllMemo()
        }

        memoListTableView.reloadData()
    }
}

extension MemoListViewController: UISearchResultsUpdating {
    // ???????????????
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsController as? SearchResultViewController,
              let text = SearchBar.searchBar.text else { return }
        
        let searchTitle = "memoTitle CONTAINS '\(text)' OR memo CONTAINS '\(text)'"
//        let searchMemo = "memo CONTAINS '\(text)'"
        let searchResultMemo = memoManeger.filterMemo(with: memos, searchTitle)
        resultController.memos = searchResultMemo
        resultController.searchResultTableView.reloadData()
    }
}
