//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2025/04/30.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentStackView: UIStackView!

    func setPostData(_ postData: PostData) {
            // 画像表示
            postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
            postImageView.sd_setImage(with: imageRef)

            // キャプション
            self.captionLabel.text = "\(postData.name) : \(postData.caption)"

            // 日付
            self.dateLabel.text = postData.date

            // いいね数
            likeLabel.text = "\(postData.likes.count)"

            // いいねボタンの見た目
            let buttonImage = postData.isLiked ? UIImage(named: "like_exist") : UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }

        //コメント表示
        func setComments(_ comments: [[String: String]]) {
            // 既存コメントをすべて削除
            commentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // 最新3件
            let recentComments = comments.suffix(3)

            if recentComments.isEmpty {
                // コメントがない場合の表示
                let label = UILabel()
                label.text = "コメントはまだありません"
                commentStackView.addArrangedSubview(label)
                return
            }

            let titleLabel = UILabel()
               titleLabel.text = "最新3件のコメントを表示："
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
            titleLabel.textColor = UIColor.red
               commentStackView.addArrangedSubview(titleLabel)
            
            // コメントをラベルにして表示
            for comment in recentComments {
                
                let label = UILabel()
                label.numberOfLines = 0
                label.font = UIFont.systemFont(ofSize: 13)

                // 安全に補間する
                let name = comment["name"] ?? ""
                let text = comment["text"] ?? ""
                label.text = "\(name): \(text)"

                commentStackView.addArrangedSubview(label)
            }
        }
    }
