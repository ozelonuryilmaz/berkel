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

final class JBCustomerHistoryCoordinator: NavigationCoordinator, IJBCustomerHistoryCoordinator {

    private var coordinatorData: JBCustomerHistoryPassData { return castPassData(JBCustomerHistoryPassData.self) }

    override func start() {
        let controller = JBCustomerHistoryBuilder.generate(with: coordinatorData,
                                                           coordinator: self)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
    }
}
