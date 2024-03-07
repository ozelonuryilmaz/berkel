//
//  WarehouseListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import UIKit

protocol IWarehouseListCoordinator: AnyObject {

    func pushNewWarehouseViewController(passData: NewWarehousePassData,
                                        successDismissCallBack: ((_ data: WarehouseModel) -> Void)?)

    func dismiss(completion: (() -> Void)?)
}

final class WarehouseListCoordinator: PresentationCoordinator, IWarehouseListCoordinator {

    private var coordinatorData: WarehouseListPassData { return castPassData(WarehouseListPassData.self) }

    private unowned var navController: MainNavigationController

    private var successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil

    @discardableResult
    func with(successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) -> WarehouseListCoordinator {
        self.successDismissCallBack = successDismissCallBack
        return self
    }

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = WarehouseListBuilder.generate(with: coordinatorData,
                                                       coordinator: self,
                                                       successDismissCallBack: self.successDismissCallBack)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }

    func pushNewWarehouseViewController(passData: NewWarehousePassData,
                                        successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) {
        let controller = NewWarehouseCoordinator(navigationController: self.navController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: passData)
        coordinate(to: controller)
    }
}



extension WarehouseListCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> WarehouseListCoordinator {
        return WarehouseListCoordinator(presenterViewController: presenterViewController,
                                        navController: MainNavigationController())
    }
}
