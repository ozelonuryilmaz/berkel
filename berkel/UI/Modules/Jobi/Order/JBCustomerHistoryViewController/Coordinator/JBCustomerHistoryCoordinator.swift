//
//  JBCustomerHistoryCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerHistoryCoordinator: AnyObject {

}

final class JBCustomerHistoryCoordinator: PresentationCoordinator, IJBCustomerHistoryCoordinator {

    private var coordinatorData: JBCustomerHistoryPassData { return castPassData(JBCustomerHistoryPassData.self) }

    override func start() {
        let controller = JBCustomerHistoryBuilder.generate(with: coordinatorData,
                                                           coordinator: self)
        let navController = MainNavigationController()
        navController.modalPresentationStyle = .fullScreen
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }
}


// Presenter
extension JBCustomerHistoryCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> JBCustomerHistoryCoordinator {
        return JBCustomerHistoryCoordinator(presenterViewController: presenterViewController)
    }
}
