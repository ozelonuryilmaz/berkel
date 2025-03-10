//
//  OrderDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IOrderDetailCoordinator: AnyObject {

    func selfPopViewController()

    func presentNewSellerImageViewController(passData: NewSellerImagePassData)
    func presentOrderCollectionViewController(passData: OrderCollectionPassData)
}

final class OrderDetailCoordinator: NavigationCoordinator, IOrderDetailCoordinator {

    private var coordinatorData: OrderDetailPassData { return castPassData(OrderDetailPassData.self) }

    private weak var outputDelegate: OrderDetailViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: OrderDetailViewControllerOutputDelegate) -> OrderDetailCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = OrderDetailBuilder.generate(with: coordinatorData,
                                                     coordinator: self,
                                                     outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true) // navigationCoordinator ise
    }

    func presentNewSellerImageViewController(passData: NewSellerImagePassData) {
        let controller = NewSellerImageCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentOrderCollectionViewController(passData: OrderCollectionPassData) {
        let controller = OrderCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func selfPopViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
