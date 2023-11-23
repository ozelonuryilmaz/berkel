//
//  SellerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol ISellerCoordinator: AnyObject {

    func pushCustomerListViewController(passData: CustomerListPassData,
                                        outputDelegate: NewSellerViewControllerOutputDelegate)
}

final class SellerCoordinator: NavigationCoordinator, ISellerCoordinator {

    private var coordinatorData: SellerPassData { return castPassData(SellerPassData.self) }

    override func start() {
        let controller = SellerBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }
    
    func pushCustomerListViewController(passData: CustomerListPassData,
                                        outputDelegate: NewSellerViewControllerOutputDelegate) {
        let coordinator = CustomerListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
}
