//
//  Category.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import Foundation
import RealmSwift

class Category: Object {
    // memoCount 사용안함ㅋ
    @Persisted var memoCount: Int
    @Persisted var categoryName: String
    @Persisted var isDefault: Bool = false
}
