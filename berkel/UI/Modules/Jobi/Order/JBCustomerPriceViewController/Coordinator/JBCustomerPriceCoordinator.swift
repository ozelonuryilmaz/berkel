//
//  JBCustomerPriceCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerPriceCoordinator: AnyObject {
    func pushJBCPriceViewController(passData: JBCPricePassData,
                                    outputDelegate: JBCPriceViewControllerOutputDelegate)
    func dismiss(completion: (() -> Void)?)
}

final class JBCustomerPriceCoordinator: PresentationCoordinator, IJBCustomerPriceCoordinator {

    private var coordinatorData: JBCustomerPricePassData { return castPassData(JBCustomerPricePassData.self) }

    private weak var outputDelegate: JBCustomerPriceViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: JBCustomerPriceViewControllerOutputDelegate) -> JBCustomerPriceCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = JBCustomerPriceBuilder.generate(with: coordinatorData,
                                                         coordinator: self,
                                                         outputDelegate: outputDelegate)

        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func pushJBCPriceViewController(passData: JBCPricePassData,
                                    outputDelegate: JBCPriceViewControllerOutputDelegate) {
        guard let navController = UIApplication.topViewController()?.navigationController else { return }
        let coordinator = JBCPriceCoordinator(navigationController: navController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}


// Presenter
extension JBCustomerPriceCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> JBCustomerPriceCoordinator {
        return JBCustomerPriceCoordinator(presenterViewController: presenterViewController)
    }
}
