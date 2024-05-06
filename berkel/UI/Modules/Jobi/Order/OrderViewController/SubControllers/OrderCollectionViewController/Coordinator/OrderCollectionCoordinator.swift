//
//  OrderCollectionCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IOrderCollectionCoordinator: AnyObject {
    
    func presentJBCustomerPriceViewController(passData: JBCustomerPricePassData,
                                              outputDelegate: JBCustomerPriceViewControllerOutputDelegate)

    func dismiss(completion: (() -> Void)?)
}

final class OrderCollectionCoordinator: PresentationCoordinator, IOrderCollectionCoordinator {

    private var coordinatorData: OrderCollectionPassData { return castPassData(OrderCollectionPassData.self) }

    private weak var outputDelegate: OrderCollectionViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: OrderCollectionViewControllerOutputDelegate) -> OrderCollectionCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        let controller = OrderCollectionBuilder.generate(with: coordinatorData,
                                                         coordinator: self,
                                                         outputDelegate: self.outputDelegate)

        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func presentJBCustomerPriceViewController(passData: JBCustomerPricePassData,
                                              outputDelegate: JBCustomerPriceViewControllerOutputDelegate) {
        let controller = JBCustomerPriceCoordinator.getInstance(presenterViewController: UIApplication.topViewController())
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}


// Presenter
extension OrderCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> OrderCollectionCoordinator {
        return OrderCollectionCoordinator(presenterViewController: presenterViewController)
    }
}
