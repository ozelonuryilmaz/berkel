//
//  SettingsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol ISettingsCoordinator: AnyObject {

    // List
    func pushAddBuyinItemViewController(passData: AddBuyingItemPassData,
                                        outputDelegate: AddBuyingItemViewControllerOutputDelegate?)
    func pushCavusListViewController(passData: CavusListPassData,
                                     outputDelegate: NewWorkerViewControllerOutputDelegate)
    func pushCustomerListViewController(passData: CustomerListPassData,
                                        outputDelegate: NewSellerViewControllerOutputDelegate)
    func pushOtherSellerListViewController(passData: OtherSellerListPassData,
                                           outputDelegate: NewOtherItemViewControllerOutputDelegate)
    
    func pushJBCustomerListViewController(passData: JBCustomerListPassData,
                                          outputDelegate: JBCustomerListViewControllerOutputDelegate)

    // Charts
    func pushBuyingChartsViewController(passData: BuyingChartsPassData)
    func pushWorkerChartsViewController(passData: WorkerChartsPassData)
    func pushSellerChartsViewController(passData: SellerChartsPassData)
    func pushOtherSellerChartsViewController(passData: OtherSellerChartsPassData)

    // Settings
    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: Bool) -> Void)?)
    func pushUserAuthsViewController()
}

final class SettingsCoordinator: NavigationCoordinator, ISettingsCoordinator {

    private var coordinatorData: SettingsPassData { return castPassData(SettingsPassData.self) }

    override func start() {
        let controller = SettingsBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

    // List

    func pushAddBuyinItemViewController(passData: AddBuyingItemPassData,
                                        outputDelegate: AddBuyingItemViewControllerOutputDelegate?) {
        let coordinator = AddBuyingItemCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushCavusListViewController(passData: CavusListPassData,
                                     outputDelegate: NewWorkerViewControllerOutputDelegate) {
        let coordinator = CavusListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushCustomerListViewController(passData: CustomerListPassData,
                                        outputDelegate: NewSellerViewControllerOutputDelegate) {
        let coordinator = CustomerListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushOtherSellerListViewController(passData: OtherSellerListPassData,
                                           outputDelegate: NewOtherItemViewControllerOutputDelegate) {
        let coordinator = OtherSellerListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
    
    func pushJBCustomerListViewController(passData: JBCustomerListPassData,
                                          outputDelegate: JBCustomerListViewControllerOutputDelegate) {
        let coordinator = JBCustomerListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    // Charts

    func pushBuyingChartsViewController(passData: BuyingChartsPassData) {
        let coordinator = BuyingChartsCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushWorkerChartsViewController(passData: WorkerChartsPassData) {
        let coordinator = WorkerChartsCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushSellerChartsViewController(passData: SellerChartsPassData) {
        let coordinator = SellerChartsCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushOtherSellerChartsViewController(passData: OtherSellerChartsPassData) {
        let coordinator = OtherSellerChartsCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
    // Settings

    func pushUserAuthsViewController() {
        let coordinator = UserAuthsCoordinator(navigationController: self.navigationController)
            .with(passData: UserAuthsPassData())
        coordinate(to: coordinator)
    }

    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: Bool) -> Void)?) {
        let coordinator = SeasonsCoordinator(presenterViewController: self.navigationController.lastViewController)
            .with(seasonDismissCallback: seasonDismissCallback)
            .with(passData: SeasonsPassData(isHiddenBackButton: false))
        DispatchQueue.delay(25) { [unowned self] in
            self.coordinate(to: coordinator)
        }
    }
}
