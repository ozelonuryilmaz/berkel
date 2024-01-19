//
//  OtherSellerListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol IOtherSellerListCoordinator: AnyObject {

    func presentNewOtherSellerViewController(passData: NewOtherSellerPassData,
                                             outputDelegate: NewOtherSellerViewControllerOutputDelegate)
    
    func presentNewOtherItemViewController(passData: NewOtherItemPassData,
                                           outputDelegate: NewOtherItemViewControllerOutputDelegate)
}

final class OtherSellerListCoordinator: NavigationCoordinator, IOtherSellerListCoordinator {

    private var coordinatorData: OtherSellerListPassData { return castPassData(OtherSellerListPassData.self) }

    private weak var outputDelegate: NewOtherItemViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewOtherItemViewControllerOutputDelegate) -> OtherSellerListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = OtherSellerListBuilder.generate(with: coordinatorData,
                                                         coordinator: self,
                                                         outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentNewOtherSellerViewController(passData: NewOtherSellerPassData,
                                             outputDelegate: NewOtherSellerViewControllerOutputDelegate) {
        let controller = NewOtherSellerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }
    
    func presentNewOtherItemViewController(passData: NewOtherItemPassData,
                                           outputDelegate: NewOtherItemViewControllerOutputDelegate) {
        let controller = NewOtherItemCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
