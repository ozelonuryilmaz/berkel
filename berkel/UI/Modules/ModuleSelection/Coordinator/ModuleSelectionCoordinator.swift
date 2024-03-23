//
//  ModuleSelectionCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IModuleSelectionCoordinator: AnyObject {

}

final class ModuleSelectionCoordinator: PresentationCoordinator, IModuleSelectionCoordinator {

    private var coordinatorData: ModuleSelectionPassData { return castPassData(ModuleSelectionPassData.self) }

    override func start() {
        let controller = ModuleSelectionBuilder.generate(with: coordinatorData,
                                                                   coordinator: self)
        let navController = MainNavigationController()
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }
}
