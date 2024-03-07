//
//  OtherCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol IOtherCoordinator: AnyObject {

    func pushOtherSellerListViewController(passData: OtherSellerListPassData,
                                           outputDelegate: NewOtherItemViewControllerOutputDelegate)
    
    func pushOtherDetailViewController(passData: OtherDetailPassData,
                                        outputDelegate: OtherDetailViewControllerOutputDelegate)
    
    func presentOtherCollectionViewController(passData: OtherCollectionPassData)
    func presentOtherPaymentViewController(passData: OtherPaymentPassData)
}

final class OtherCoordinator: NavigationCoordinator, IOtherCoordinator {

    private var coordinatorData: OtherPassData { return castPassData(OtherPassData.self) }

    override func start() {
        let controller = OtherBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

    func pushOtherSellerListViewController(passData: OtherSellerListPassData,
                                         outputDelegate: NewOtherItemViewControllerOutputDelegate) {
        let coordinator = OtherSellerListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
    
    func pushOtherDetailViewController(passData: OtherDetailPassData,
                                       outputDelegate: OtherDetailViewControllerOutputDelegate) {
        let coordinator = OtherDetailCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
    
    func presentOtherCollectionViewController(passData: OtherCollectionPassData) {
        let controller = OtherCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentOtherPaymentViewController(passData: OtherPaymentPassData) {
        let controller = OtherPaymentCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
