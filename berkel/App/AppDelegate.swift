//
//  AppDelegate.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.08.2023.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Keyboard Manager
        self.initIQKeyboardManager()
        
        // start Coordinator
        self.startAppCoordinator()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: Helper funcs
extension AppDelegate {
    
    private func startAppCoordinator() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: window)
        self.window = window
        
        self.startFlowMain()
    }

    func startFlowSplash() {
        self.appCoordinator.start()
    }

    func startFlowMain() {
        self.appCoordinator.startFlowMain()
    }
}

// MARK: Setup
extension AppDelegate {
    
    func initIQKeyboardManager() {
        // IQKeyboardManager
        let keyboardSharedManager = IQKeyboardManager.shared
        keyboardSharedManager.enable = true
        keyboardSharedManager.toolbarTintColor = .primaryBlue
        keyboardSharedManager.toolbarDoneBarButtonItemText = "Kapat"
        keyboardSharedManager.shouldResignOnTouchOutside = true
    }
}
