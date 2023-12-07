//
//  SellerDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

protocol ISellerDetailCoordinator: AnyObject {

    func selfPopViewController()
    
    func presentNewSellerImageViewController(passData: NewSellerImagePassData)
    func presentSellerCollectionViewController(passData: SellerCollectionPassData)
}

final class SellerDetailCoordinator: NavigationCoordinator, ISellerDetailCoordinator {

    private var coordinatorData: SellerDetailPassData { return castPassData(SellerDetailPassData.self) }

    private weak var outputDelegate: SellerDetailViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: SellerDetailViewControllerOutputDelegate) -> SellerDetailCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = SellerDetailBuilder.generate(with: coordinatorData,
                                                      coordinator: self,
                                                      outputDelegate: outputDelegate)

        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentNewSellerImageViewController(passData: NewSellerImagePassData) {
        let controller = NewSellerImageCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
    
    func presentSellerCollectionViewController(passData: SellerCollectionPassData) {
        let controller = SellerCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func selfPopViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
