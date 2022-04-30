//
//  Memo.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted var id: UUID = UUID()
    @Persisted var memoTitle: String
    @Persisted var memo: String
    @Persisted var isSecret: Bool
    @Persisted var password: Int?
    @Persisted var memoDate: String
    @Persisted var star: Bool = false
    @Persisted var category: String
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
