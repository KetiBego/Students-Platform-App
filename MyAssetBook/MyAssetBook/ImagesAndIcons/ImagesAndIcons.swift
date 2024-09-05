//
//  ImagesAndIcons.swift
//  MyAssetBook
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
public struct Icons {
    
    public static let books = ImageWrapper(name: "books.vertical")
    public static let search = ImageWrapper(name: "magnifyingglass")
    public static let chat = ImageWrapper(name: "message")
    public static let profile = ImageWrapper(name: "person.crop.circle")
    public static let more =  UIImage(systemName: "ellipsis")
    public static let upVote =  UIImage(systemName: "arrowshape.up")
    public static let upVoted =  UIImage(systemName: "arrowshape.up.fill")
    public static let imageIcon = ImageWrapper(name: "photo")
    public static let pdfIcon = ImageWrapper(name: "doc.text.image")
}

public struct Image {
    public static let AppLogo = UIImage(named: "AppLogo",
                                        in:  Bundle(identifier: "Free-University.MyAssetBook"),
                                        compatibleWith: nil)!
    public static let person = ImageWrapper(name: "person")
}

public struct MyLottie {
    public static let loader = "Loader"
    public static let registrationAnimation = "RegistrationAnimation"
    
}
