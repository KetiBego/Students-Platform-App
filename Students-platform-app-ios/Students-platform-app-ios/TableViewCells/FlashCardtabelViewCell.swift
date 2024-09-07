//
//  FlashCardtabelViewCell.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking
import MyAssetBook
class FlashcardTableViewCell: UITableViewCell {

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .XL2)
        label.textColor = Color.Blue2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .XL2)
        label.textColor = Color.Blue2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()

    private var isAnswerVisible = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        self.backgroundColor = Color.background
        contentView.layer.cornerRadius = .S
        contentView.backgroundColor = Color.Yellow2
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerLabel)
               
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
               
            answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            answerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTap() {
        UIView.animate(withDuration: 0.3, animations: {
            self.questionLabel.alpha = self.isAnswerVisible ? 1 : 0
            self.answerLabel.alpha = self.isAnswerVisible ? 0 : 1
        })
        isAnswerVisible.toggle()
    }

    func configure(with flashcard: FlashcardEntity) {
        questionLabel.text = flashcard.question
        answerLabel.text = flashcard.answer
    }
}
