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

    func pushSellerDetailViewController(passData: SellerDetailPassData,
                                        outputDelegate: SellerDetailViewControllerOutputDelegate)

    func presentSellerCollectionViewController(passData: SellerCollectionPassData)
    func presentSellerPaymentViewController(passData: SellerPaymentPassData)
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

    func pushSellerDetailViewController(passData: SellerDetailPassData,
                                        outputDelegate: SellerDetailViewControllerOutputDelegate) {
        let coordinator = SellerDetailCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func presentSellerCollectionViewController(passData: SellerCollectionPassData) {
        let controller = SellerCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentSellerPaymentViewController(passData: SellerPaymentPassData) {
        let controller = SellerPaymentCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
