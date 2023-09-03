//
//  AppDelegate.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.08.2023.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase
        FirebaseApp.configure()
        
        // Keyboard Manager
        self.initIQKeyboardManager()
        
        // start Coordinator
        self.startAppCoordinator()

        return true
    }
}

// MARK: Helper funcs
extension AppDelegate {
    
    private func startAppCoordinator() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: window)
        self.window = window
        
        self.startFlowSplash()
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
