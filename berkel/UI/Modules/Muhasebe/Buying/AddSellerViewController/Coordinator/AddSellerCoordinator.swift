//
//  AddSellerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//

import UIKit

protocol IAddSellerCoordinator: AnyObject {

    func dismiss()
}

final class AddSellerCoordinator: PresentationCoordinator, IAddSellerCoordinator {

    private var coordinatorData: AddSellerPassData { return castPassData(AddSellerPassData.self) }

    private unowned var navController: MainNavigationController

    private weak var outputDelegate: AddSellerViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: AddSellerViewControllerOutputDelegate) -> AddSellerCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = AddSellerBuilder.generate(with: coordinatorData,
                                                   coordinator: self,
                                                   outputDelegate: outputDelegate)
        //controller.modalPresentationStyle = .fullScreen
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss() {
        navController.dismiss(animated: true)
    }
}

extension AddSellerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> AddSellerCoordinator {
        return AddSellerCoordinator(presenterViewController: presenterViewController,
                                    navController: MainNavigationController())
    }
}
