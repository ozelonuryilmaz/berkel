//
//  OtherCollectionCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import UIKit

protocol IOtherCollectionCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class OtherCollectionCoordinator: PresentationCoordinator, IOtherCollectionCoordinator {

    private var coordinatorData: OtherCollectionPassData { return castPassData(OtherCollectionPassData.self) }

    private unowned var navController: MainNavigationController // Presenter

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = OtherCollectionBuilder.generate(with: coordinatorData,
                                                         coordinator: self)

        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension OtherCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> OtherCollectionCoordinator {
        return OtherCollectionCoordinator(presenterViewController: presenterViewController,
                                          navController: MainNavigationController())
    }
}
