//
//  SubjectCell.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 01.09.24.
//

import Networking
import UIKit
import MyAssetBook

class SubjectTableViewCell: UITableViewCell {
    
    var moreButtonTapped: (() -> Void)?


    let subjectNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: .L)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Icons.more, for: .normal)
        button.tintColor = .black
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
        contentView.backgroundColor = Color.background
        contentView.addSubview(subjectNameLabel)
        contentView.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            subjectNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .L),
            subjectNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subjectNameLabel.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -(.S)),
            
            
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(.L)),
            moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: .XL2),  // Adjust width if needed
            moreButton.heightAnchor.constraint(equalToConstant: .XL2)  // Adjust height if needed
        ])
        
        moreButton.addTarget(self, action: #selector(moreButtonTappedAction), for: .touchUpInside)
    }

    
    
     @objc private func moreButtonTappedAction() {
         moreButtonTapped?()
     }
    
    func configure(with subject: SubjectEntity) {
        subjectNameLabel.text = subject.subjectName
    }
    
}
