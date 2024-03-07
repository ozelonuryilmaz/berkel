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

    private unowned var navController: MainNavigationController

    private weak var outputDelegate: NewSellerViewControllerOutputDelegate? = nil

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

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

        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
    
    func presentProductListViewController(outputDelegate: ProductListViewControllerOutputDelegate) {
        let controller =  ProductListCoordinator.getInstance(presenterViewController: self.navController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData:  ProductListPassData())
        coordinate(to: controller)
    }
}

// Presenter
extension NewSellerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewSellerCoordinator {
        return NewSellerCoordinator(presenterViewController: presenterViewController,
                                    navController: MainNavigationController())
    }
}
