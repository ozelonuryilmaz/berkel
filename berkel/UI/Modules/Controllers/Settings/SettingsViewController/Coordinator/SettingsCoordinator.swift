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

    // Season
    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: Bool) -> Void)?)
    
    func pushSellerChartsViewController(passData: SellerChartsPassData) 
}

final class SettingsCoordinator: NavigationCoordinator, ISettingsCoordinator {

    private var coordinatorData: SettingsPassData { return castPassData(SettingsPassData.self) }

    override func start() {
        let controller = SettingsBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

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

    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: Bool) -> Void)?) {
        let coordinator = SeasonsCoordinator(presenterViewController: self.navigationController.lastViewController)
            .with(seasonDismissCallback: seasonDismissCallback)
            .with(passData: SeasonsPassData(isHiddenBackButton: false))
        DispatchQueue.delay(25) { [unowned self] in
            self.coordinate(to: coordinator)
        }
    }

    func pushSellerChartsViewController(passData: SellerChartsPassData) {
        let coordinator = SellerChartsCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
}
