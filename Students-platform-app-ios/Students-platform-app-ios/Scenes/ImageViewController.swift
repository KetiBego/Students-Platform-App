//
//  ImageViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 04.09.24.
//

import UIKit

class ImageViewController: UIViewController {
    private let imageView = UIImageView()
    private let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light) // Adjust the style as needed
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        loadImage()
    }
    
    private func setupImageView() {
        view.addSubview(blurView)
        blurView.topNotSafe(toView: view)
        blurView.bottomNotSafe(toView: view)
        blurView.left(toView: view)
        blurView.right(toView: view)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func loadImage() {
        if let data = try? Data(contentsOf: imageURL) {
            imageView.image = UIImage(data: data)
        }
    }
}
