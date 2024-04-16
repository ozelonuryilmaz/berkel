//
//  NewJBCustomerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol INewJBCustomerCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class NewJBCustomerCoordinator: PresentationCoordinator, INewJBCustomerCoordinator {

    private var coordinatorData: NewJBCustomerPassData { return castPassData(NewJBCustomerPassData.self) }

    private weak var outputDelegate: NewJBCustomerViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewJBCustomerViewControllerOutputDelegate) -> NewJBCustomerCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewJBCustomerBuilder.generate(with: coordinatorData,
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
extension NewJBCustomerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewJBCustomerCoordinator {
        return NewJBCustomerCoordinator(presenterViewController: presenterViewController)
    }
}
