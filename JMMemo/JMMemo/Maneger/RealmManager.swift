//
//  RealmManager.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import Foundation
import RealmSwift

class CategoryRealmManeger {
    
     
    private func setRealm() -> Realm? {
        do {
            return try Realm()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Category Maneger
    public func saveCategory(with data: Category) {
        
        let realm = setRealm()
        
        do {
            try realm?.write {
                realm?.add(data)
            } 
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getAllCategory() -> (default: Results<Category>?, userAdd: Results<Category>?) {
        let realm = setRealm()
        
        let allCategorys = realm?.objects(Category.self)
        let defaultCategory = allCategorys?.filter("isDefault == true")
        let userAddCategory = allCategorys?.filter("isDefault == false")
        
        return (defaultCategory, userAddCategory)
    }
    
    public func deleteCategory(with data: Category) {
        let realm = setRealm()
        
        do {
            try realm?.write {
                realm?.delete(data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

enum UpdateMemoQuery {
    case title
    case memo
    case isSecret
    case password
    case star
    case category
}

class MemoRealmManeger {
    
    private func setRealm() -> Realm? {
        do {
            return try Realm()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK: - Memo Maneger
    public func saveMemo(with data: Memo) {
        
        let realm = setRealm()
        
        do {
            try realm?.write {
                realm?.add(data, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getAllMemo() -> Results<Memo>? {
        let realm = setRealm()
        
        let allMemo = realm?.objects(Memo.self).sorted(byKeyPath: "memoDate", ascending: false)
        
        return allMemo
    }
    
    public func deleteMemo(with data: Memo) {
        let realm = setRealm()
        
        do {
            try realm?.write {
                realm?.delete(data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func filterMemo(with memos: Results<Memo>?, _ filter: String) -> Results<Memo>? {
        return memos?.filter(filter)
    }
    
    public func updateMemo(memo: Memo?, query: UpdateMemoQuery, data: Any?) {
        let realm = setRealm()
        
        do {
            switch query {
            case .title:
                try realm?.write {
                    memo?.memoTitle = data as! String
                }
            case .memo:
                try realm?.write {
                    memo?.memo = data as! String
                }
            case .isSecret:
                try realm?.write {
                    memo?.isSecret = data as! Bool
                }
            case .password:
                try realm?.write {
                    memo?.password = data as! Int?
                }
            case .star:
                try realm?.write {
                    memo?.star = data as! Bool
                }
            case .category:
                try realm?.write {
                    memo?.category = data as! String
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
