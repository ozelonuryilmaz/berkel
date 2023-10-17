//
//  BuyingDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingDetailCoordinator: AnyObject {

    func presentWarehouseListViewController(passData: WarehouseListPassData,
                                            successDismissCallBack: ((_ data: WarehouseModel) -> Void)?)
}

final class BuyingDetailCoordinator: NavigationCoordinator, IBuyingDetailCoordinator {

    private var coordinatorData: BuyingDetailPassData { return castPassData(BuyingDetailPassData.self) }

    override func start() {
        let controller = BuyingDetailBuilder.generate(with: coordinatorData, coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentWarehouseListViewController(passData: WarehouseListPassData,
                                            successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) {
        let controller = WarehouseListCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
