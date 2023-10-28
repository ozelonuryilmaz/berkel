//
//  NewWarehouseCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import UIKit

protocol INewWarehouseCoordinator: AnyObject {

    func selfPopViewController()
}

final class NewWarehouseCoordinator: NavigationCoordinator, INewWarehouseCoordinator {

    private var coordinatorData: NewWarehousePassData { return castPassData(NewWarehousePassData.self) }

    private var successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil

    @discardableResult
    func with(successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) -> NewWarehouseCoordinator {
        self.successDismissCallBack = successDismissCallBack
        return self
    }

    override func start() {
        let controller = NewWarehouseBuilder.generate(with: coordinatorData,
                                                      coordinator: self,
                                                      successDismissCallBack: self.successDismissCallBack)
        navigationController.pushViewController(controller, animated: true)
    }

    func selfPopViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
