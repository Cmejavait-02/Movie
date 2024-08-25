//
//  SplashViewController.swift
//  Movie
//
//  Created by Bishwajit Yadav on 26/08/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show the splash screen for 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.transitionToMainViewController()
        }
    }
    
    private func transitionToMainViewController() {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            
            let mainViewController = MainViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            
            // Set the new root view controller
            if let window = scene.windows.first {
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}
