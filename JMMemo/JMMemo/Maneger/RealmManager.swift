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


