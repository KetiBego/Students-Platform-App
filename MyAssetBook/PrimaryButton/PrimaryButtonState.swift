//
//  PrimaryButtonState.swift
//  MyAssetBook
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit

enum PrimaryButtonState {
    case enabled
    case disabled
    case loading
    
    var backgroundColor: UIColor {
        switch self {
        case .enabled:
            return Color.LightBlue2
        case .disabled:
            return Color.DisabledButtonBackground
        case .loading:
            return Color.LightBlue1
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .enabled:
            return Color.Yellow1
        case .disabled:
            return Color.background
        case .loading:
            return Color.Yellow2
        }
    }
}

