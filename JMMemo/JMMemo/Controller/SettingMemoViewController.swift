//
//  SettingMemoViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/29.
//

import UIKit
import RealmSwift

class SettingMemoViewController: UIViewController {
    
    struct CategoryCellData {
        var categories: [String] = [] {
            willSet {
                currentCategory = newValue[0]
            }
        }
        var currentCategory: String = ""
        var isOpen: Bool = false
    }
    
    // MARK: - Properties
    public var memoObject: Memo?
    private let categoryManeger = CategoryRealmManeger()
    private var categoryData = CategoryCellData()
//    private var categories: [String] = []
    public var isEditMode = false
    private let memoManeger = MemoRealmManeger()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SelectCategoryCell.self, forCellReuseIdentifier: SelectCategoryCell.identifier)
        tableView.register(CategoryListCell.self, forCellReuseIdentifier: CategoryListCell.identifier)
        tableView.register(SetMemoPasswordCell.self, forCellReuseIdentifier: SetMemoPasswordCell.identifier)
        tableView.register(SetMemoStarCell.self, forCellReuseIdentifier: SetMemoStarCell.identifier)
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getAllCategories()
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Method
    // 전체 카테고리 가져오기
    private func getAllCategories() {
        categoryManeger.getAllCategory().userAdd?.forEach {
            categoryData.categories.append($0.categoryName)
        }
        print(categoryData.categories)
    }
    
    // 카테고리 이름만 뽑기?
    public func configure(category: String) {
        if category != "", category != "전체", category != "즐겨찾기" {
            categoryData.categories.append(category)
        } else {
            categoryData.categories.append("Category")
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingMemoViewController: UITableViewDataSource {
//    섹션개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // 섹션헤더
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Category"
        case 1:
            return "비밀번호"
        case 2:
            return "즐겨찾기"
        default:
            return ""
        }
    }
    
    // 섹션별 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if categoryData.isOpen {
                // 카테고리 열렸을때
                return categoryData.categories.count
            } else {
                // 카테고리 닫혔을때
                return 1
            }
        default:
            return 1
        }
    }
    
    // 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // 맨 상위 셀( 항상보임 )
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectCategoryCell.identifier, for: indexPath) as? SelectCategoryCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                
                cell.configure(categoryData.isOpen, currentCategory: categoryData.currentCategory)
                
                return cell
            default:
                // 열렸을때 보이는 셀 ( 현제 카테고리 체크표시 )
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryListCell.identifier, for: indexPath) as? CategoryListCell else { return UITableViewCell() }
                
                cell.selectionStyle = .none
                
                let isSelected = categoryData.currentCategory == categoryData.categories[indexPath.row]
                cell.configure(categoryData.categories[indexPath.row], isSelected: isSelected)
                
                return cell
            }
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetMemoPasswordCell.identifier, for: indexPath) as? SetMemoPasswordCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.memo = memoObject
            cell.isEditMode = isEditMode
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetMemoStarCell.identifier, for: indexPath) as? SetMemoStarCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.memo = memoObject
            cell.isEditMode = isEditMode
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingMemoViewController: UITableViewDelegate {
    // 셀 눌렀을때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            // 카테고리셀
        case 0:
            switch indexPath.row {
                // 맨 상위셀 ( 항상보임 ) -> 오픈, 클로스
            case 0:
                categoryData.isOpen.toggle()
                tableView.reloadSections([indexPath.section], with: .none)
            default:
                // 열렸을때 셀 -> 선택시 카테고리변경
                categoryData.categories[0] = categoryData.categories[indexPath.row]
                if !isEditMode {
                    memoObject?.category = categoryData.categories[0]
                } else {
                    let query = UpdateMemoQuery.category
                    memoManeger.updateMemo(memo: memoObject, query: query, data: categoryData.categories[0])
                }
                categoryData.isOpen = false
                tableView.reloadSections([indexPath.section], with: .none)
            }
        default:
            break
        }
    }
}
