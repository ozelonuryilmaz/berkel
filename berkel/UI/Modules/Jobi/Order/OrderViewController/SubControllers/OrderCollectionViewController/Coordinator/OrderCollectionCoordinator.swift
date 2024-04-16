//
//  OrderCollectionCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IOrderCollectionCoordinator: AnyObject {

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
        guard let outputDelegate = outputDelegate else { return }

        let controller = OrderCollectionBuilder.generate(with: coordinatorData,
                                                         coordinator: self,
                                                         outputDelegate: outputDelegate)

        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }
}


// Presenter
extension OrderCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> OrderCollectionCoordinator {
        return OrderCollectionCoordinator(presenterViewController: presenterViewController)
    }
}
