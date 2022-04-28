//
//  Memo.swift
//  JMMemo
//
//  Created by J_Min on 2022/04/28.
//

import Foundation

struct Memo {
    let id = UUID()
    var memoTitle: String
    var memo: String
    var isSecret: Bool
    var password: Int?
    var memoDate: String
}

let dummyMemoList: [Memo] = [
    Memo(memoTitle: "타이틀1", memo: "메모1", isSecret: true, memoDate: "2022.04.28"),
    Memo(memoTitle: "타이틀2", memo: "메모2", isSecret: false, memoDate: "2022.04.28"),
    Memo(memoTitle: "타이틀3", memo: "메모3", isSecret: false, memoDate: "2022.04.28"),
    Memo(memoTitle: "타이틀4", memo: "메모4", isSecret: false, memoDate: "2022.04.28"),
]
