//
//  AddBuyingItemCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//

import UIKit

protocol IAddBuyingItemCoordinator: AnyObject {

    func presentAddSellerViewController(outputDelegate: AddSellerViewControllerOutputDelegate)

    func presentNewBuyingViewController(passData: AddBuyingItemResponseModel,
                                        successDismissCallBack: ((_ data: NewBuyingModel) -> Void)?)

    func pushArchiveListViewController(passData: ArchiveListPassData)
    func selfPopViewController()
}

final class AddBuyingItemCoordinator: NavigationCoordinator, IAddBuyingItemCoordinator {

    private var coordinatorData: AddBuyingItemPassData { return castPassData(AddBuyingItemPassData.self) }

    private weak var outputDelegate: AddBuyingItemViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: AddBuyingItemViewControllerOutputDelegate?) -> AddBuyingItemCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = AddBuyingItemBuilder.generate(with: coordinatorData,
                                                       coordinator: self,
                                                       outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentAddSellerViewController(outputDelegate: AddSellerViewControllerOutputDelegate) {
        let controller = AddSellerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: AddSellerPassData())
        coordinate(to: controller)
    }

    func presentNewBuyingViewController(passData: AddBuyingItemResponseModel,
                                        successDismissCallBack: ((_ data: NewBuyingModel) -> Void)?) {
        let controller = NewBuyingCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(successDismissCallBack: successDismissCallBack)
            .with(passData: NewBuyingPassData(seller: passData))
        coordinate(to: controller)
    }

    func pushArchiveListViewController(passData: ArchiveListPassData) {
        let coordinator = ArchiveListCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func selfPopViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
