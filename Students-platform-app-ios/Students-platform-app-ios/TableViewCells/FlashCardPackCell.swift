//
//  FlashCardPackCell.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking
import MyAssetBook

class FlashcardPackTableViewCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.Blue2
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.Blue2
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Color.background
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(nameLabel)
        contentView.layer.cornerRadius = .M
        contentView.addSubview(creatorLabel)
        contentView.backgroundColor = Color.Yellow2

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            creatorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            creatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            creatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            creatorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with pack: FlashcardPack) {
        nameLabel.text = pack.name
        creatorLabel.text = "ავტორი: \(pack.creatorUsername)"
    }
}
