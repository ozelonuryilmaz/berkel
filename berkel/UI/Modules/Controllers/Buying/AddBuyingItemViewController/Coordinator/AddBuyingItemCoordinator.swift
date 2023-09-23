//
//  AddBuyingItemCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IAddBuyingItemCoordinator: AnyObject {

    func presentAddSellerViewController(outputDelegate: AddSellerViewControllerOutputDelegate)

    func presentNewBuyingViewController(passData: AddBuyingItemResponseModel)
}

final class AddBuyingItemCoordinator: NavigationCoordinator, IAddBuyingItemCoordinator {

    private var coordinatorData: AddBuyingItemPassData { return castPassData(AddBuyingItemPassData.self) }

    override func start() {
        let controller = AddBuyingItemBuilder.generate(with: coordinatorData, coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentAddSellerViewController(outputDelegate: AddSellerViewControllerOutputDelegate) {
        let controller = AddSellerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: AddSellerPassData())
        coordinate(to: controller)
    }

    func presentNewBuyingViewController(passData: AddBuyingItemResponseModel) {
        let controller = NewBuyingCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: NewBuyingPassData(seller: passData))
        coordinate(to: controller)
    }
}
