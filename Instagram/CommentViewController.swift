//
//  CommentViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2025/05/01.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!

    var postData: PostData!
    var comments: [[String:String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        comments = postData.comments // 投稿されてるコメント一覧を取得
    }

    @IBAction func handleSendButton(_ sender: Any) {
        guard let comment = commentTextField.text, !comment.isEmpty,
              let name = Auth.auth().currentUser?.displayName else {
            return
        }

        // 名前とコメント
        let commentData = ["name": name, "text": comment]
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)

        //新しいコメントを追加
        postRef.updateData([
            "comments": FieldValue.arrayUnion([commentData])
        ]) { [weak self] error in
            if let error = error {
                print("コメント送信失敗: \(error)")
                return
            }

            // コメント送信成功時の処理
            self?.comments.append(commentData)
            self?.tableView.reloadData()
            self?.commentTextField.text = ""
            print("コメント送信成功")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") ?? UITableViewCell(style: .default, reuseIdentifier: "CommentCell")
        let comment = comments[indexPath.row]
        let name = comment["name"] ?? ""
        let text = comment["text"] ?? ""
        cell.textLabel?.text = "\(name): \(text)"
        return cell
    }
}
