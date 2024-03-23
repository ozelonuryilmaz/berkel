//
//  SellerCollectionCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

protocol ISellerCollectionCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class SellerCollectionCoordinator: PresentationCoordinator, ISellerCollectionCoordinator {

    private var coordinatorData: SellerCollectionPassData { return castPassData(SellerCollectionPassData.self) }

    override func start() {
        let controller = SellerCollectionBuilder.generate(with: coordinatorData,
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
extension SellerCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> SellerCollectionCoordinator {
        return SellerCollectionCoordinator(presenterViewController: presenterViewController)
    }
}
