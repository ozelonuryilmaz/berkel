//
//  BuyingDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingDetailCoordinator: AnyObject {

    func selfPopViewController()

    func presentWarehouseListViewController(passData: WarehouseListPassData,
                                            successDismissCallBack: ((_ data: WarehouseModel) -> Void)?)

    func presentBuyingCollectionViewController(passData: BuyingCollectionPassData,
                                               successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?)

    func presentNewSellerImageViewController(passData: NewSellerImagePassData)
}

final class BuyingDetailCoordinator: NavigationCoordinator, IBuyingDetailCoordinator {

    private var coordinatorData: BuyingDetailPassData { return castPassData(BuyingDetailPassData.self) }

    private var successDismissCallBack: ((_ isActive: Bool) -> Void)? = nil

    @discardableResult
    func with(successDismissCallBack: ((_ isActive: Bool) -> Void)?) -> BuyingDetailCoordinator {
        self.successDismissCallBack = successDismissCallBack
        return self
    }

    override func start() {
        let controller = BuyingDetailBuilder.generate(with: coordinatorData,
                                                      coordinator: self,
                                                      successDismissCallBack: self.successDismissCallBack)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentWarehouseListViewController(passData: WarehouseListPassData,
                                            successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) {
        let controller = WarehouseListCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentBuyingCollectionViewController(passData: BuyingCollectionPassData,
                                               successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?) {
        let controller = BuyingCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentNewSellerImageViewController(passData: NewSellerImagePassData) {
        let controller = NewSellerImageCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func selfPopViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
