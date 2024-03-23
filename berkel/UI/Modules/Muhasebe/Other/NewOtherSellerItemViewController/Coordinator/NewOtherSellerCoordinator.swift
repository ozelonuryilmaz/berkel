//
//  NewOtherSellerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol INewOtherSellerCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)

    func presentOtherSellerCategoryListViewController(outputDelegate: OtherSellerCategoryListViewControllerOutputDelegate)
}

final class NewOtherSellerCoordinator: PresentationCoordinator, INewOtherSellerCoordinator {

    private var coordinatorData: NewOtherSellerPassData { return castPassData(NewOtherSellerPassData.self) }

    private weak var outputDelegate: NewOtherSellerViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewOtherSellerViewControllerOutputDelegate) -> NewOtherSellerCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewOtherSellerBuilder.generate(with: coordinatorData,
                                                        coordinator: self,
                                                        outputDelegate: outputDelegate)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }

    func presentOtherSellerCategoryListViewController(outputDelegate: OtherSellerCategoryListViewControllerOutputDelegate) {
        guard let lastViewController = UIApplication.topViewController()?.navigationController?.lastViewController else { return }
        let controller = OtherSellerCategoryListCoordinator.getInstance(presenterViewController: lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: OtherSellerCategoryListPassData())
        coordinate(to: controller)
    }
}

// Presenter
extension NewOtherSellerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewOtherSellerCoordinator {
        return NewOtherSellerCoordinator(presenterViewController: presenterViewController)
    }
}
