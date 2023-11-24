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

    private unowned var navController: MainNavigationController // Presenter

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }
    
    override func start() {
        let controller = SellerCollectionBuilder.generate(with: coordinatorData,
                                                                   coordinator: self)

        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension SellerCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> SellerCollectionCoordinator {
        return SellerCollectionCoordinator(presenterViewController: presenterViewController,
                                                    navController: MainNavigationController())
    }
}
