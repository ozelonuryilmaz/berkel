//
//  SplashCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

protocol ISplashCoordinator: AnyObject {
    
    func presentLoginViewController(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?)
    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: String) -> Void)?)
    func presentModuleSelectionViewController()
}

final class SplashCoordinator: RootableCoordinator , ISplashCoordinator {
    
    private var coordinatorData: SplashPassData { return castPassData(SplashPassData.self) }
    
    override func start() {
        let controller = SplashBuilder.generate(coordinator: self)
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    func presentLoginViewController(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) {
        let coordinator = LoginCoordinator(presenterViewController: self.window?.topViewController())
            .with(authDismissCallBack: authDismissCallBack)
            .with(passData: LoginPassData())
        DispatchQueue.delay(25) { [unowned self] in
            self.coordinate(to: coordinator)
        }
    }
    
    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: String) -> Void)?) {
        let coordinator = SeasonsCoordinator(presenterViewController: self.window?.topViewController())
            .with(seasonDismissCallback: seasonDismissCallback)
            .with(passData: SeasonsPassData(isHiddenBackButton: true))
        DispatchQueue.delay(25) { [unowned self] in
            self.coordinate(to: coordinator)
        }
    }
    
    func presentModuleSelectionViewController() {
        let coordinator = ModuleSelectionCoordinator(presenterViewController: self.window?.topViewController())
            .with(passData: ModuleSelectionPassData())
        DispatchQueue.delay(25) { [unowned self] in
            self.coordinate(to: coordinator)
        }
    }
}
