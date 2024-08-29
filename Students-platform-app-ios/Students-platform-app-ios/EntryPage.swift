//
//  ViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 10.05.24.
//

import UIKit
import Networking

class EntryPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testButton = UIButton(type: .system)
        
        // Set the button title
        testButton.setTitle("Test Button", for: .normal)
        testButton.isEnabled = true
        
        testButton.isUserInteractionEnabled = true
        
        // Set the button's position and size
        testButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        
        // Set the background color (optional)
        testButton.backgroundColor = UIColor.systemBlue
        
        // Set the button title color
        testButton.setTitleColor(UIColor.white, for: .normal)
        
        // Add target for the button to handle the tap event
        testButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        // Add the button to the view
        self.view.addSubview(testButton)
        }
        
        // Function to be called when the button is pressed
    @objc func buttonPressed() {
        print("here")
        let nextViewController = testController()
        
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }
    

}
    
   
//    
//    func presentSecondViewController() {
//        self.navigationController?.setViewControllers([TabBarController()], animated: true)
//    }
//    










