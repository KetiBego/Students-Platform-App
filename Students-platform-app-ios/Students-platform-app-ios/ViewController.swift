//
//  ViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 10.05.24.
//

import UIKit
import Networking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tst = Test()
//        tst.printHello()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentSecondViewController()
    }
    
    func presentSecondViewController() {
        let tabBarController = TabBarController()
        self.present(tabBarController, animated: true, completion: nil)
    }


}

