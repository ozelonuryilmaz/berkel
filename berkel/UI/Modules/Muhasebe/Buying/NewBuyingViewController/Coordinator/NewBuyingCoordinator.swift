//
//  NewBuyingCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//

import UIKit

protocol INewBuyingCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
    func presentProductListViewController(outputDelegate: ProductListViewControllerOutputDelegate)
}

final class NewBuyingCoordinator: PresentationCoordinator, INewBuyingCoordinator {

    private var coordinatorData: NewBuyingPassData { return castPassData(NewBuyingPassData.self) }

    private var successDismissCallBack: ((_ data: NewBuyingModel) -> Void)? = nil

    @discardableResult
    func with(successDismissCallBack: ((_ data: NewBuyingModel) -> Void)?) -> NewBuyingCoordinator {
        self.successDismissCallBack = successDismissCallBack
        return self
    }

    override func start() {
        let controller = NewBuyingBuilder.generate(with: coordinatorData,
                                                   coordinator: self,
                                                   successDismissCallBack: self.successDismissCallBack)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }

    func presentProductListViewController(outputDelegate: ProductListViewControllerOutputDelegate) {
        guard let lastViewController = UIApplication.topViewController()?.navigationController?.lastViewController else { return }
        let controller = ProductListCoordinator.getInstance(presenterViewController: lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: ProductListPassData())
        coordinate(to: controller)
    }
}


extension NewBuyingCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewBuyingCoordinator {
        return NewBuyingCoordinator(presenterViewController: presenterViewController)
    }
}
