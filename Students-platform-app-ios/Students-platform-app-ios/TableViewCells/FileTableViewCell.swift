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
    var deleteButtonTapped: (() -> Void)?

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
 
    
    // 3-dot button for more options
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icons.delete, for: .normal)
        button.tintColor = Color.Red
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
    
    private func setupCell() {
        // Add your UI components to the cell's contentView
        contentView.backgroundColor = Color.background
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
        
        
        // Set up constraints for your UI components
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .L),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -(.S)),
            
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .L),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -(.S)),
            
            
            // Constraints for the more button
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(.L)),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: .XL2),  // Adjust width if needed
            deleteButton.heightAnchor.constraint(equalToConstant: .XL2)  // Adjust height if needed
        ])
        
        // Optionally, add an action for the button
        deleteButton.addTarget(self, action: #selector(moreButtonTappedAction), for: .touchUpInside)
    }
    
    
     @objc private func moreButtonTappedAction() {
         deleteButtonTapped?()
     }
    
    func configure(with file: MyFileEntity) {
        let fileNameWithoutExtension = (file.fileName! as NSString).deletingPathExtension
        titleLabel.text = fileNameWithoutExtension
        
        // Set icon based on file type
        let fileExtension = (file.fileName! as NSString).pathExtension.lowercased()
        switch fileExtension {
        case "pdf":
            icon.image = Icons.pdfIcon.image
        case "jpg", "jpeg", "png":
            icon.image = Icons.imageIcon.image
        default:
            icon.image = UIImage(systemName: "questionmark")
        }
    }
}

