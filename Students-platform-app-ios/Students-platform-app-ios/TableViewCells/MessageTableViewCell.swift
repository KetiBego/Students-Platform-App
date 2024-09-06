//
//  MessageTableViewCell.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking

class MessageTableViewCell: UITableViewCell {

    private let messageLabel = UILabel()
    private let bubbleView = UIView()
    
    var isCurrentUser: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        bubbleView.layer.cornerRadius = 15
        bubbleView.clipsToBounds = true
        
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textColor = .black
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        // Layout constraints
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -15),
        ])
    }
    
    private func updateAppearance() {
        if isCurrentUser {
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            
            NSLayoutConstraint.deactivate([
                bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                bubbleView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8)
            ])
            
            NSLayoutConstraint.activate([
                bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: 8)
            ])
        } else {
            bubbleView.backgroundColor = .systemGray5
            messageLabel.textColor = .black
            
            NSLayoutConstraint.deactivate([
                bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: 8)
            ])
            
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: -8)
            ])
        }
    }
    
    func configure(with message: PostMessageEntity, isCurrentUser: Bool) {
        self.isCurrentUser = isCurrentUser
        messageLabel.text = message.message
    }
}
