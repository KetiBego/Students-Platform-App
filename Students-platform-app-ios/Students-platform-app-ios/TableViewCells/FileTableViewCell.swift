//
//  FileTableViewCell.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 04.09.24.
//

import UIKit
import MyAssetBook
import Networking

class FileTableViewCell: UITableViewCell {
    var upVoteButtonTapped: (() -> Void)?
    private var file: MyFileEntity?

    private lazy var icon: UIImageView = {
        let image = UIImageView()
        image.tintColor = Color.Blue2
        image.translatesAutoresizingMaskIntoConstraints = false
        image.width(equalTo: .XL4)
        image.height(equalTo: .XL4)
        image.contentMode = .scaleAspectFit
        return image
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: .L)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .M)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let upVoteCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: .M)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()

    
    // 3-dot button for more options
    let upVoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icons.upVote, for: .normal)
        button.tintColor = Color.Yellow2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    public func downVote() {
        upVoteButton.setImage(Icons.upVote, for: .normal)
    }
    
    public func upVote() {
        upVoteButton.setImage(Icons.upVoted, for: .normal)
    }
    
    private func setupCell() {
        contentView.height(equalTo: .XL8)
        contentView.backgroundColor = Color.background
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(upVoteButton)
        contentView.addSubview(upVoteCountLabel)
        
        
        // Set up constraints for your UI components
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .L),
               icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               icon.widthAnchor.constraint(equalToConstant: .XL4),
               icon.heightAnchor.constraint(equalToConstant: .XL4),
               
               titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: .M),
               titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .M),
               titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: upVoteButton.leadingAnchor, constant: -(.M)),
               
               descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
               descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .S),
               descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
               
               upVoteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(.L)),
               upVoteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               upVoteButton.widthAnchor.constraint(equalToConstant: .XL2),
               upVoteButton.heightAnchor.constraint(equalToConstant: .XL2),
               
               upVoteCountLabel.trailingAnchor.constraint(equalTo: upVoteButton.leadingAnchor, constant: -(.S)),
               upVoteCountLabel.centerYAnchor.constraint(equalTo: upVoteButton.centerYAnchor)
])
        
        upVoteButton.addTarget(self, action: #selector(upvoteButtonTappedAction), for: .touchUpInside)
    }
    
     @objc private func upvoteButtonTappedAction() {
         upVoteButtonTapped?()
         if ((file?.isUpvoted)!){
             downVote()
             file?.isUpvoted = false
             file?.upvoteCount! -= 1
         }
         else {
             file?.isUpvoted = true
             file?.upvoteCount! += 1
             upVote()
         }
         upVoteCountLabel.text = file?.upvoteCount?.description
         self.layoutSubviews()
     }
    
    func configure(with file: MyFileEntity) {
        self.file = file
        let fileNameWithoutExtension = (file.fileName! as NSString).deletingPathExtension
        titleLabel.text = fileNameWithoutExtension
        descriptionLabel.text = "ავტორი:" + (file.username ?? "")
        
        upVoteCountLabel.text = file.upvoteCount?.description
        
        let fileExtension = (file.fileName! as NSString).pathExtension.lowercased()
        switch fileExtension {
        case "pdf":
            icon.image = Icons.pdfIcon.image
        case "jpg", "jpeg", "png":
            icon.image = Icons.imageIcon.image
        default:
            icon.image = UIImage(systemName: "questionmark")
        }
        
        if file.isUpvoted ?? false {
            upVoteButton.setImage(Icons.upVoted, for: .normal)
        }
    }
}

