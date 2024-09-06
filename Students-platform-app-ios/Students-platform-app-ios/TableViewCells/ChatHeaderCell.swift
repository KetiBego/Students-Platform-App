//
//  ChatHeaderCell.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking

class ConversationTableViewCell: UITableViewCell {
    
    private let usernameLabel = UILabel()
    private let lastMessageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(usernameLabel)
        contentView.addSubview(lastMessageLabel)
    }
    
    private func addConstraints() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            usernameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            usernameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            lastMessageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            lastMessageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            lastMessageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with conversation: ConversationEntity) {
        usernameLabel.text = conversation.username
        lastMessageLabel.text = conversation.lastMessage?.message
    }
}
