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

    private var successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil

    @discardableResult
    func with(successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) -> WarehouseListCoordinator {
        self.successDismissCallBack = successDismissCallBack
        return self
    }

    override func start() {
        let controller = WarehouseListBuilder.generate(with: coordinatorData,
                                                       coordinator: self,
                                                       successDismissCallBack: self.successDismissCallBack)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }

    func pushNewWarehouseViewController(passData: NewWarehousePassData,
                                        successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) {
        guard let navController = UIApplication.topViewController()?.navigationController else { return }
        let controller = NewWarehouseCoordinator(navigationController: navController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: passData)
        coordinate(to: controller)
    }
}



extension WarehouseListCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> WarehouseListCoordinator {
        return WarehouseListCoordinator(presenterViewController: presenterViewController)
    }
}
