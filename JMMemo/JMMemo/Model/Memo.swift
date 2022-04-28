//
//  Memo.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted var id = UUID()
    @Persisted var memoTitle: String
    @Persisted var memo: String
    @Persisted var isSecret: Bool
    @Persisted var password: Int?
    @Persisted var memoDate: String
    @Persisted var star: Bool = false
}

//struct Memo {
//    var id = UUID()
//     var memoTitle: String
//     var memo: String
//     var isSecret: Bool
//     var password: Int?
//     var memoDate: String
//     var star: Bool = false
//}


//let dummyMemoList: [Memo] = [
//    Memo(memoTitle: "타이틀1", memo: "메모1", isSecret: true, memoDate: "2022.04.28"),
//    Memo(memoTitle: "타이틀2", memo: "메모2", isSecret: false, memoDate: "2022.04.28"),
//    Memo(memoTitle: "타이틀3", memo: "메모3", isSecret: false, memoDate: "2022.04.28"),
//    Memo(memoTitle: "타이틀4", memo: "메모4", isSecret: false, memoDate: "2022.04.28"),
//]
