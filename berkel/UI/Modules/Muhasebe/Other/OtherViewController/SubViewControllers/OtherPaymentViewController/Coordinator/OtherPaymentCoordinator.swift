//
//  OtherPaymentCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit

protocol IOtherPaymentCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class OtherPaymentCoordinator: PresentationCoordinator, IOtherPaymentCoordinator {

    private var coordinatorData: OtherPaymentPassData { return castPassData(OtherPaymentPassData.self) }

    private unowned var navController: MainNavigationController

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = OtherPaymentBuilder.generate(with: coordinatorData,
                                                                   coordinator: self)

        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension OtherPaymentCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> OtherPaymentCoordinator {
        return OtherPaymentCoordinator(presenterViewController: presenterViewController,
                                                    navController: MainNavigationController())
    }
}
