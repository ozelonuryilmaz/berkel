//
//  OrderCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IOrderCoordinator: AnyObject {

    func pushJBCustomerListViewController(passData: JBCustomerListPassData,
                                          outputDelegate: JBCustomerListViewControllerOutputDelegate)
}

final class OrderCoordinator: NavigationCoordinator, IOrderCoordinator {

    private var coordinatorData: OrderPassData { return castPassData(OrderPassData.self) }

    override func start() {
        let controller = OrderBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }


    func pushJBCustomerListViewController() {
        
    }
    
    func pushJBCustomerListViewController(passData: JBCustomerListPassData,
                                          outputDelegate: JBCustomerListViewControllerOutputDelegate) {
        let coordinator = JBCustomerListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
}
