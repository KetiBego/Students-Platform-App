//
//  MessageTableViewCell.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking
import MyAssetBook

class MessageTableViewCell: UITableViewCell {

    private let messageLabel = UILabel()
    private let bubbleView = UIView()
    private let timestampLabel = UILabel()

    
    private var bubbleLeadingConstraint: NSLayoutConstraint!
    private var bubbleTrailingConstraint: NSLayoutConstraint!
    private var timestampLeadingConstraint: NSLayoutConstraint!
    private var timestampTrailingConstraint: NSLayoutConstraint!
    
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
        messageLabel.textColor = Color.Blue3
        
        timestampLabel.font = .systemFont(ofSize: 12)
        timestampLabel.textColor = .black

        contentView.addSubview(timestampLabel)
        contentView.backgroundColor = Color.background
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        // Layout constraints
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        timestampLeadingConstraint = timestampLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor)
        timestampTrailingConstraint = timestampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor)

        
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),


            bubbleView.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 4),
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
            // Message from the current user, bubble on the right
            bubbleView.backgroundColor = Color.Blue1
            messageLabel.textColor = Color.Yellow1
            
            bubbleLeadingConstraint.isActive = false
            bubbleTrailingConstraint.isActive = true
            timestampLeadingConstraint.isActive = false
            timestampTrailingConstraint.isActive = true
        } else {
            // Message from another user, bubble on the left
            bubbleView.backgroundColor = Color.Yellow2
            messageLabel.textColor = Color.Blue3
            
            timestampTrailingConstraint.isActive = false
            timestampLeadingConstraint.isActive = true
            bubbleTrailingConstraint.isActive = false
            bubbleLeadingConstraint.isActive = true
        }
    }
    func configure(with message: PostMessageEntity, isCurrentUser: Bool) {
            self.isCurrentUser = isCurrentUser
            messageLabel.text = message.message
            
            if let date = parseDate(from: message.createdAt) {
                let formattedDate = formatDate(date: date)
                timestampLabel.text = formattedDate
            } else {
                timestampLabel.text = "Unknown Date"
            }
        }

    private func parseDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: string)
    }

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a" 
        return dateFormatter.string(from: date)
    }

}
