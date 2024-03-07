//
//  OtherDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit

protocol IOtherDetailCoordinator: AnyObject {

    func selfPopViewController()
    
    func presentNewSellerImageViewController(passData: NewSellerImagePassData)
    func presentOtherCollectionViewController(passData: OtherCollectionPassData)
}

final class OtherDetailCoordinator: NavigationCoordinator, IOtherDetailCoordinator {

    private var coordinatorData: OtherDetailPassData { return castPassData(OtherDetailPassData.self) }

    private weak var outputDelegate: OtherDetailViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: OtherDetailViewControllerOutputDelegate) -> OtherDetailCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }
        
        let controller = OtherDetailBuilder.generate(with: coordinatorData,
                                                     coordinator: self,
                                                     outputDelegate: outputDelegate)

        navigationController.pushViewController(controller, animated: true)
    }

    func presentNewSellerImageViewController(passData: NewSellerImagePassData) {
        let controller = NewSellerImageCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
    
    func presentOtherCollectionViewController(passData: OtherCollectionPassData) {
        let controller = OtherCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func selfPopViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
