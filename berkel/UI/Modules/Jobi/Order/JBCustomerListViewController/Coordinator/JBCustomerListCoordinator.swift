//
//  JBCustomerListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCustomerListCoordinator: AnyObject {

    func presentNewJBCustomerViewController(passData: NewJBCustomerPassData,
                                            outputDelegate: NewJBCustomerViewControllerOutputDelegate)
    func presentJBCustomerPriceViewController(passData: JBCustomerPricePassData,
                                              outputDelegate: JBCustomerPriceViewControllerOutputDelegate)
    func presentNewOrderViewController(passData: NewOrderPassData,
                                       outputDelegate: NewOrderViewControllerOutputDelegate)
    func pushArchiveListViewController(passData: ArchiveListPassData)
    func pushJBCustomerHistoryViewController(passData: JBCustomerHistoryPassData)
    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: String) -> Void)?)
    func popToRootViewController(animated: Bool)
}

final class JBCustomerListCoordinator: NavigationCoordinator, IJBCustomerListCoordinator {

    private var coordinatorData: JBCustomerListPassData { return castPassData(JBCustomerListPassData.self) }

    private weak var outputDelegate: JBCustomerListViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: JBCustomerListViewControllerOutputDelegate) -> JBCustomerListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = JBCustomerListBuilder.generate(with: coordinatorData,
                                                        coordinator: self,
                                                        outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentNewJBCustomerViewController(passData: NewJBCustomerPassData,
                                            outputDelegate: NewJBCustomerViewControllerOutputDelegate) {
        let controller = NewJBCustomerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentJBCustomerPriceViewController(passData: JBCustomerPricePassData,
                                              outputDelegate: JBCustomerPriceViewControllerOutputDelegate) {
        let controller = JBCustomerPriceCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentNewOrderViewController(passData: NewOrderPassData,
                                       outputDelegate: NewOrderViewControllerOutputDelegate) {
        let controller = NewOrderCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func pushArchiveListViewController(passData: ArchiveListPassData) {
        let coordinator = ArchiveListCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushJBCustomerHistoryViewController(passData: JBCustomerHistoryPassData) {
        let coordinator = JBCustomerHistoryCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        DispatchQueue.delay(25) { [unowned self] in
            self.coordinate(to: coordinator)
        }
    }

    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: String) -> Void)?) {
        let coordinator = SeasonsCoordinator(presenterViewController: self.navigationController.lastViewController)
            .with(seasonDismissCallback: seasonDismissCallback)
            .with(passData: SeasonsPassData(isHiddenBackButton: false))
        DispatchQueue.delay(25) { [unowned self] in
            self.coordinate(to: coordinator)
        }
    }

    func popToRootViewController(animated: Bool) {
        self.navigationController.popToRootViewController(animated: animated)
    }
}
