//
//  LocalLabelViewModel.swift
//  MyAssetBook
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import Combine

public class LocalLabelModel: ObservableObject {
    var text: String?
    var color: UIColor
    var font: UIFont
    var action: (() -> Void)?
    
    public init(text: String? = nil,
                color: UIColor = Color.Blue3,
                font: UIFont = .systemFont(ofSize: .L),
                action: (() -> Void)? = nil) {
        self.text =  text
        self.color = color
        self.font = font
        self.action = action
    }
}
