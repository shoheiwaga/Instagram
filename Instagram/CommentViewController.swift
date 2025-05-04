//
//  CommentViewController.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2025/05/01.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InputAccessoryViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var postData: PostData!
    var comments: [[String:String]] = []

    
    private lazy var myInputAccessoryView: InputAccessoryView = {
        let view = InputAccessoryView()
        view.delegate = self
        return view
    }()

    override var inputAccessoryView: UIView? { myInputAccessoryView }
    override var canBecomeFirstResponder: Bool { true }

    override func viewDidLoad() {
            super.viewDidLoad()

            tableView.delegate = self
            tableView.dataSource = self

            fetchComments()
        }

        // コメントを読み込み
        private func fetchComments() {
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)

            postRef.getDocument { [weak self] document, error in
                if let error = error {
                    print("コメント取得失敗: \(error.localizedDescription)")
                    return
                }

                if let data = document?.data(),
                   let loadedComments = data["comments"] as? [[String: String]] {
                    DispatchQueue.main.async {
                        self?.comments = loadedComments
                        self?.tableView.reloadData()
                        print("あり:", loadedComments)
                    }
                } else {
                    print("なし")
                }
            }
        }

        // コメント送信
        func inputAccessoryView(_ inputAccessoryView: InputAccessoryView, didTapSendWith text: String) {
            guard !text.isEmpty,
                  let name = Auth.auth().currentUser?.displayName else {
                return
            }

            let commentData = ["name": name, "text": text]
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)

            postRef.updateData([
                "comments": FieldValue.arrayUnion([commentData])
            ]) { [weak self] error in
                if let error = error {
                    print("コメント送信失敗: \(error)")
                    return
                }

                DispatchQueue.main.async {
                    self?.myInputAccessoryView.clearText()
                    self?.fetchComments() // ← Firestoreから再取得して表示を更新
                    print("コメント送信成功")
                }
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
