//
//  CategoryListViewController.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import UIKit

class CategoryListViewController: UIViewController {
    
    // MARK: - Properties
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
        
        configureNavBar()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.collectionViewLayout = layout()
        
        view.addSubview(categoryCollectionView)
        view.addSubview(floatingButton)
        floatingButton.addSubview(buttonImage)
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
        
        let vc = MemoListViewController()
        navigationController?.pushViewController(vc, animated: true)
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
            return 10
        default:
            break
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCategoryCollectionViewCell.identifier, for: indexPath) as? DefaultCategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure()
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserAddCategoryCollectionViewCell.identifier, for: indexPath) as? UserAddCategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configure()
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
        
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryListViewController: UICollectionViewDelegate {
    
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
