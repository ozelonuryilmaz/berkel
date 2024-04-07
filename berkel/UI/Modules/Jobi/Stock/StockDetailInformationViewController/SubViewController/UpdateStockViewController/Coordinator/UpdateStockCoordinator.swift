//
//  UpdateStockCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IUpdateStockCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class UpdateStockCoordinator: PresentationCoordinator, IUpdateStockCoordinator {

    private var coordinatorData: UpdateStockPassData { return castPassData(UpdateStockPassData.self) }

    private weak var outputDelegate: UpdateStockViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: UpdateStockViewControllerOutputDelegate) -> UpdateStockCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = UpdateStockBuilder.generate(with: coordinatorData,
                                                     coordinator: self,
                                                     outputDelegate: outputDelegate)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension UpdateStockCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> UpdateStockCoordinator {
        return UpdateStockCoordinator(presenterViewController: presenterViewController)
    }
}
