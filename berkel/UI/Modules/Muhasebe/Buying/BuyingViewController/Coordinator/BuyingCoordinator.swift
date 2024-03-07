//
//  BuyingCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol IBuyingCoordinator: AnyObject {

    func pushAddBuyinItemViewController(outputDelegate: AddBuyingItemViewControllerOutputDelegate?)
    func pushBuyingDetailViewController(passData: BuyingDetailPassData,
                                        successDismissCallBack: ((_ isActive: Bool) -> Void)?)
    func presentBuyingCollectionViewController(passData: BuyingCollectionPassData,
                                               successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?)
    func presentBuyingPaymentViewController(passData: BuyingPaymentPassData)
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

    func pushBuyingDetailViewController(passData: BuyingDetailPassData,
                                        successDismissCallBack: ((_ isActive: Bool) -> Void)?) {
        let coordinator = BuyingDetailCoordinator(navigationController: self.navigationController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func presentBuyingCollectionViewController(passData: BuyingCollectionPassData,
                                               successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?) {
        let controller = BuyingCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentBuyingPaymentViewController(passData: BuyingPaymentPassData) {
        let controller = BuyingPaymentCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
