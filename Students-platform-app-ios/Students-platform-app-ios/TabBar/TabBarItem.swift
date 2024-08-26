//
//  TabBarItem.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook
enum TabBarItem {
    case Subjects
    case Search
    case Chat
    case Profile
    
    
    var text: String {
        switch self {
        case .Subjects:
            return "საგნები"
        case .Search:
            return "ძებნა"
        case .Chat:
            return "ჩათი"
        case .Profile:
            return "პროფილი"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .Subjects:
            return Icons.books.image
        case .Search:
            return Icons.search.image
        case .Chat:
            return Icons.chat.image
        case .Profile:
            return Icons.profile.image
        }
    }
    
    var controller: UIViewController {
        switch self {
        case .Subjects:
            return SubjectsViewController()
        case .Search:
            return SubjectsViewController()
        case .Chat:
            return SubjectsViewController()
        case .Profile:
            return SubjectsViewController()
        }
    }
}
