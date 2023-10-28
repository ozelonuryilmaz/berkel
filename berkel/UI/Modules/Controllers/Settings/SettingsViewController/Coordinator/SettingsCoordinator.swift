//
//  SettingsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol ISettingsCoordinator: AnyObject {

}

final class SettingsCoordinator: NavigationCoordinator, ISettingsCoordinator {

    private var coordinatorData: SettingsPassData { return castPassData(SettingsPassData.self) }

    override func start() {
        let controller = SettingsBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }
}
