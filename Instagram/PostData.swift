//
//  PostData.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2025/04/30.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostData: NSObject {
    var id = ""
    var name = ""
    var caption = ""
    var date = ""
    var likes: [String] = []
    var isLiked: Bool = false
    var comments: [[String: String]] = [] // コメント配列

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()

        // 投稿者の名前
        if let name = postDic["name"] as? String {
            self.name = name
        }

        // キャプション
        if let caption = postDic["caption"] as? String {
            self.caption = caption
        }

        // 投稿日時の変換
        if let timestamp = postDic["date"] as? Timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.date = formatter.string(from: timestamp.dateValue())
        }

        // いいねしたユーザー
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }

        // いいね済みか確認
        if let myid = Auth.auth().currentUser?.uid {
            self.isLiked = self.likes.contains(myid)
        }

        // コメント取得
        if let comments = postDic["comments"] as? [[String: String]] {
            self.comments = comments
        }
    }

    override var description: String {
        return "PostData: name=\(name); caption=\(caption); date=\(date); likes=\(likes.count); id=\(id);"
    }
}
