//
//  BuyingCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingCoordinator: AnyObject {

    func pushAddBuyinItemViewController(outputDelegate: AddBuyingItemViewControllerOutputDelegate?)
}

final class BuyingCoordinator: NavigationCoordinator, IBuyingCoordinator {

    private var coordinatorData: BuyingPassData { return castPassData(BuyingPassData.self) }

    override func start() {
        let controller = BuyingBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

    func pushAddBuyinItemViewController(outputDelegate: AddBuyingItemViewControllerOutputDelegate?) {
        let coordinator = AddBuyingItemCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: AddBuyingItemPassData())
        coordinate(to: coordinator)
    }
}
