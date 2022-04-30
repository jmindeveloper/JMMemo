//
//  CategoryListViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit
import RealmSwift

class CategoryListViewController: UIViewController {
    
    // MARK: - Properties
    private let categoryManeger = CategoryRealmManeger()
    private let memoManeger = MemoRealmManeger()
    private var categorys: (default: Results<Category>?, userAdd: Results<Category>?)? = nil {
        willSet {
            categoryCollectionView.reloadData()
        }
    }
    private var memos: Results<Memo>?
    private var categoryDeleteMode = false
    
    private let categoryCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserAddCategoryCollectionViewCell.self, forCellWithReuseIdentifier: UserAddCategoryCollectionViewCell.identifier)
        collectionView.register(DefaultCategoryCollectionViewCell.self, forCellWithReuseIdentifier: DefaultCategoryCollectionViewCell.identifier)
        
        return collectionView
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
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        categorys = categoryManeger.getAllCategory()
        memos = memoManeger.getAllMemo()
        
        configureNavBar()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.collectionViewLayout = layout()
        
        view.addSubview(categoryCollectionView)
        view.addSubview(floatingButton)
        floatingButton.addSubview(buttonImage)
        
        floatingButton.addTarget(self, action: #selector(creatNewCategory(_:)), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewLayoutMarginsDidChange()
        
        categoryCollectionView.snp.makeConstraints {
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
        navigationItem.title = "Category"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(deleteMode(_:)))
        navigationItem.rightBarButtonItems = [deleteButton]
        navigationController?.navigationBar.tintColor = .label
        
        let vc = MemoListViewController()
        vc.memos = memos
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func creatNewCategory(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: "New Category", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let categoryName = alert.textFields?[0].text,
                  categoryName != "" else { return }
            let newCategory = Category()
            newCategory.categoryName = categoryName
            newCategory.memoCount = 0
            
            self.categoryManeger.saveCategory(with: newCategory)
            self.categorys = self.categoryManeger.getAllCategory()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addTextField { tf in
            tf.placeholder = "Category Name"
            tf.autocapitalizationType = .sentences
            tf.autocorrectionType = .no
            tf.spellCheckingType = .no
            tf.returnKeyType = .done
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @objc func deleteMode(_ sender: UIBarButtonItem) {
        categoryDeleteMode.toggle()
        print(categoryDeleteMode)
        categoryCollectionView.reloadData()
    }
    
    private func filterMemo(_ filter: String) -> Results<Memo>? {
        return memos?.filter(filter)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return categorys?.userAdd?.count ?? 0
        default:
            break
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCategoryCollectionViewCell.identifier, for: indexPath) as? DefaultCategoryCollectionViewCell else { return UICollectionViewCell() }
            
            let categoryName = categorys?.default?[indexPath.row].categoryName ?? "전체"
            switch indexPath.row {
            case 0:
                let count = String(memos?.count ?? 0)
                let categoryViewModeol = CategoryViewModel(categoryName: categoryName, count: count)
                
                cell.configure(with: categoryViewModeol)
                
                return cell
            case 1:
                let count = String(filterMemo("star == false")?.count ?? 0)
                let categoryViewModeol = CategoryViewModel(categoryName: categoryName, count: count)
                
                cell.configure(with: categoryViewModeol)
                
                return cell
            default:
                return UICollectionViewCell()
            }
           
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserAddCategoryCollectionViewCell.identifier, for: indexPath) as? UserAddCategoryCollectionViewCell else { return UICollectionViewCell() }
            
            let categoryName = categorys?.userAdd?[indexPath.row].categoryName ?? "전체"
//            let count = String(categorys?.userAdd?[indexPath.row].memoCount ?? 0)
            let filterStr = "category == '\(categoryName)'"
            let count = String(filterMemo(filterStr)?.count ?? 0)
            
            let categoryViewModeol = CategoryViewModel(categoryName: categoryName, count: count)
            
            cell.configure(with: categoryViewModeol)
            cell.deleteMode(categoryDeleteMode)
            cell.delegate = self
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryDeleteMode = false
        categoryCollectionView.reloadData()
        
        let vc = MemoListViewController()
        
        switch indexPath.section {
        case 0:
            vc.navigationTitle = categorys?.default?[indexPath.row].categoryName ?? "Memo"
            switch indexPath.row {
            case 0:
                vc.memos = memos
            case 1:
                vc.memos = filterMemo("star == false")
            default:
                break
            }
            
        case 1:
            vc.navigationTitle = categorys?.userAdd?[indexPath.row].categoryName ?? "Memo"
            let categoryName = categorys?.userAdd?[indexPath.row].categoryName ?? ""
            
            let filterStr = "category == '\(categoryName)'"
            vc.memos = filterMemo(filterStr)
        default:
            break
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UserAddCategoryCollectionViewCellDelegate
extension CategoryListViewController: UserAddCategoryCollectionViewCellDelegate {
    
    // 눌린 deletebutton이 있는 cell의 indexPath 가져오기
    func getCategoryCollectionViewCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let contentView = sender.superview
        let cell = contentView?.superview as! UICollectionViewCell
        
        if let indexPath = categoryCollectionView.indexPath(for: cell) {
            return indexPath
        }
        return nil
    }
    
    // cell 삭제
    func delete(_ sender: UIButton) {
        guard let indexPath = getCategoryCollectionViewCellIndexPath(sender) else { return }
        guard let deleteCategory = categorys?.userAdd?[indexPath.row] else { return }
        
        let alert = UIAlertController(title: nil, message: "\(deleteCategory.categoryName)카테고리를 진짜 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.categoryManeger.deleteCategory(with: deleteCategory)
            self.categorys = self.categoryManeger.getAllCategory()
            
            UIView.transition(with: self.categoryCollectionView, duration: 0.1, options: .transitionCrossDissolve) { [weak self] in
                guard let self = self else { return }
                self.categoryCollectionView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

// MARK: - CollectionView Layout
extension CategoryListViewController {
    private func creatDefaultCellLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(110))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
        
        return section
    }
    
    private func creatUserAddCellLayout() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
    
    func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, _) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            switch section {
            case 0:
                return self.creatDefaultCellLayout()
            case 1:
                return self.creatUserAddCellLayout()
            default:
                return nil
            }
        }
    }
}
