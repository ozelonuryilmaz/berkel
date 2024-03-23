//
//  NewSellerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit

protocol INewSellerCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
    
    func presentProductListViewController(outputDelegate: ProductListViewControllerOutputDelegate)
}

final class NewSellerCoordinator: PresentationCoordinator, INewSellerCoordinator {

    private var coordinatorData: NewSellerPassData { return castPassData(NewSellerPassData.self) }

    private weak var outputDelegate: NewSellerViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewSellerViewControllerOutputDelegate) -> NewSellerCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewSellerBuilder.generate(with: coordinatorData,
                                                   coordinator: self,
                                                   outputDelegate: outputDelegate)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
    
    func presentProductListViewController(outputDelegate: ProductListViewControllerOutputDelegate) {
        guard let lastViewController = UIApplication.topViewController()?.navigationController?.lastViewController else { return }
        let controller =  ProductListCoordinator.getInstance(presenterViewController: lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData:  ProductListPassData())
        coordinate(to: controller)
    }
}

// Presenter
extension NewSellerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewSellerCoordinator {
        return NewSellerCoordinator(presenterViewController: presenterViewController)
    }
}
