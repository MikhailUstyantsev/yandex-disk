//
//  AppDelegate.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 27.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationCon = UINavigationController()
        window?.rootViewController = navigationCon
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(navigationCon)
        appCoordinator?.start()
        
        return true
    }

    
    
    
    
    
    
    
    func delay(delay: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            completion()
        })
    }
    
}

