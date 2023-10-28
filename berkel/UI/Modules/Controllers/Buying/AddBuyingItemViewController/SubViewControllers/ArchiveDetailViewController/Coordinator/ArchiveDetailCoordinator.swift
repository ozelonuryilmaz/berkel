//
//  ArchiveDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

protocol IArchiveDetailCoordinator: AnyObject {

}

final class ArchiveDetailCoordinator: PresentationCoordinator, IArchiveDetailCoordinator {

    private var coordinatorData: ArchiveDetailPassData { return castPassData(ArchiveDetailPassData.self) }

    private unowned var navController: MainNavigationController

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = ArchiveDetailBuilder.generate(with: coordinatorData, coordinator: self)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }
}


extension ArchiveDetailCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> ArchiveDetailCoordinator {
        return ArchiveDetailCoordinator(presenterViewController: presenterViewController,
                                        navController: MainNavigationController())
    }
}

