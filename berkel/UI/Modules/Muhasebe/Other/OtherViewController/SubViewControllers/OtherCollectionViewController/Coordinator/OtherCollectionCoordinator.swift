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

    override func start() {
        let controller = OtherCollectionBuilder.generate(with: coordinatorData,
                                                         coordinator: self)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension OtherCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> OtherCollectionCoordinator {
        return OtherCollectionCoordinator(presenterViewController: presenterViewController)
    }
}
