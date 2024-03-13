//
//  AppCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

protocol AppCoordinatorFlow: AnyObject {

    func startFlowAccounting()
    func startFlowJobi()
}

class AppCoordinator: RootableCoordinator, AppCoordinatorFlow {
    
    var callbackIsPreparedMainScreen: (() -> Void)?
    
    override func start() {
        let splashCoordinator = SplashCoordinator(window: self.window)
        coordinate(to: splashCoordinator)
    }
    
    func startFlowAccounting() {
        let tabbarCoordinator = MainTabbarCoordinator(window: self.window)
        tabbarCoordinator.callbackIsPreparedMainScreen = callbackIsPreparedMainScreen
        coordinate(to: tabbarCoordinator)
    }
    
    func startFlowJobi() {
        let tabbarCoordinator = JobiTabbarCoordinator(window: self.window)
        tabbarCoordinator.callbackIsPreparedMainScreen = callbackIsPreparedMainScreen
        coordinate(to: tabbarCoordinator)
    }
}
