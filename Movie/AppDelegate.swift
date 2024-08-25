//
//  AppDelegate.swift
//  Movie
//
//  Created by Bishwajit Yadav on 26/08/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            // Initialize the window
            window = UIWindow(frame: UIScreen.main.bounds)
            
            // Set the SplashViewController as the root view controller
            let splashViewController = SplashViewController()
            window?.rootViewController = splashViewController
            window?.makeKeyAndVisible()
            
            return true
        }
    }

    



