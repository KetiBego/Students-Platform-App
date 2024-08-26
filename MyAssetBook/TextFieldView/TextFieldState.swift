//
//  TextFieldState.swift
//  MyAssetBook
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit

enum textFieldState {
    case inactive
    case inProgressOfEditing
    
    var placeholderColor: UIColor {
        switch self {
        case .inactive:
            return Color.background
        case .inProgressOfEditing:
            return Color.background
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .inactive:
            return  .clear
        case .inProgressOfEditing:
            return Color.Blue3
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .inactive:
            return Color.Yellow2
        case .inProgressOfEditing:
            return Color.Yellow1
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .inactive:
            return  Color.Blue1
        case .inProgressOfEditing:
            return Color.Blue3
        }
    }
}
