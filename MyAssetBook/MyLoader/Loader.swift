//
//  Loader.swift
//  MyAssetBook
//
//  Created by Ruska Keldishvili on 31.08.24.
//

import Lottie

import UIKit


public class Loader {
    public static let shared = Loader()
    
    let animationView: LottieAnimationView = {
        let animation = LottieAnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.backgroundBehavior = .pauseAndRestore
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animation = .named(MyLottie.loader, bundle: Bundle(identifier: "Free-University.MyAssetBook")!)
        animation.width(equalTo: 150)
        animation.height(equalTo: 150)
        return animation
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light) // Adjust the style as needed
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private init() {}
    
    public func show() {
        
        if let windowScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .first as? UIWindowScene {
            if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                // Now you have the key window
                window.addSubview(blurView)
                
                self.blurView.topNotSafe(toView: window)
                self.blurView.bottomNotSafe(toView: window)
                self.blurView.left(toView: window)
                self.blurView.right(toView: window)
                self.blurView.contentView.addSubview(animationView)
                
                self.animationView.centerVertically(to: blurView)
                animationView.centerHorizontally(to: blurView)
                animationView.play()
            }
        }
        
    
    }
    
    public func hide() {
        animationView.stop()
        animationView.removeFromSuperview()
        blurView.removeFromSuperview()
    }
}

