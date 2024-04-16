//
//  JBCustomerListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerListCoordinator: AnyObject {

    func presentNewJBCustomerViewController(passData: NewJBCustomerPassData,
                                            outputDelegate: NewJBCustomerViewControllerOutputDelegate)
}

final class JBCustomerListCoordinator: NavigationCoordinator, IJBCustomerListCoordinator {

    private var coordinatorData: JBCustomerListPassData { return castPassData(JBCustomerListPassData.self) }

    private weak var outputDelegate: JBCustomerListViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: JBCustomerListViewControllerOutputDelegate) -> JBCustomerListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = JBCustomerListBuilder.generate(with: coordinatorData,
                                                        coordinator: self,
                                                        outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentNewJBCustomerViewController(passData: NewJBCustomerPassData,
                                            outputDelegate: NewJBCustomerViewControllerOutputDelegate) {
        let controller = NewJBCustomerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
