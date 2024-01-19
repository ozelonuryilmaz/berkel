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
}
