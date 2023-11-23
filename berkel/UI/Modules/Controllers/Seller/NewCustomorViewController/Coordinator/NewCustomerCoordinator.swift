//
//  NewCustomerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit

protocol INewCustomerCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class NewCustomerCoordinator: PresentationCoordinator, INewCustomerCoordinator {

    private var coordinatorData: NewCustomerPassData { return castPassData(NewCustomerPassData.self) }

    private unowned var navController: MainNavigationController

    private weak var outputDelegate: NewCustomerViewControllerOutputDelegate? = nil

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    @discardableResult
    func with(outputDelegate: NewCustomerViewControllerOutputDelegate) -> NewCustomerCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewCustomerBuilder.generate(with: coordinatorData,
                                                     coordinator: self,
                                                     outputDelegate: outputDelegate)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension NewCustomerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewCustomerCoordinator {
        return NewCustomerCoordinator(presenterViewController: presenterViewController,
                                      navController: MainNavigationController())
    }
}
