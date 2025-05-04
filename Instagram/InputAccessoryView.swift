//
//  InputAccessoryView.swift
//  Instagram
//
//  Created by PC-SYSKAI555 on 2025/05/04.
//

import UIKit

protocol InputAccessoryViewDelegate: AnyObject {
    func inputAccessoryView(_ inputAccessoryView: InputAccessoryView, didTapSendWith text: String)
}

final class InputAccessoryView: UIView {

    weak var delegate: InputAccessoryViewDelegate?

    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 12
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("送信", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        autoresizingMask = .flexibleHeight
        addSubview(textView)
        addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),

            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            sendButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    override var intrinsicContentSize: CGSize {
        return .zero // 高さは textView の内容に応じて伸縮する
    }

    func clearText() {
        textView.text = ""
    }

    @objc private func didTapSendButton() {
        delegate?.inputAccessoryView(self, didTapSendWith: textView.text)
    }
}









//import UIKit
//protocol InputAccessoryViewDelegate: AnyObject {
//    func inputAccessoryView(_ inputAccessoryView: InputAccessoryView, didTapSendWith text: String)
//}
//
//final class InputAccessoryView: UIView {
//    
//    @IBOutlet private weak var textView: UITextView!
//    @IBOutlet private weak var sendButton: UIButton!
//    
//    weak var delegate: InputAccessoryViewDelegate?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        loadNib()
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        loadNib()
//        setupViews()
//    }
//
//
//    func clearText() {
//        //textView.text = ""
//    }
//
//    @IBAction private func didTapSendButton(_ sender: UIButton) {
//        print("Buttom Tap: \(textView.text ?? "nil")")
//        delegate?.inputAccessoryView(self, didTapSendWith: textView.text)
//    }
//
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
//    }
//}
//
//private extension InputAccessoryView {
//    func loadNib() {
//        let nib = UINib(nibName: String(describing: InputAccessoryView.self), bundle: nil)
//        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
//            print("読み込み失敗")
//            return
//        }
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(view)
//        print("読み込み成功")
//    }
//
//    func setupViews() {
//        textView.layer.cornerRadius = 15
//        sendButton.layer.cornerRadius = 15
//    }
//}
//
//extension InputAccessoryView {
//    static func instantiateFromNib() -> InputAccessoryView {
//        let nib = UINib(nibName: "InputAccessoryView", bundle: nil)
//        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? InputAccessoryView else {
//            fatalError("InputAccessoryView のロードに失敗しました")
//        }
//        return view
//    }
//}
