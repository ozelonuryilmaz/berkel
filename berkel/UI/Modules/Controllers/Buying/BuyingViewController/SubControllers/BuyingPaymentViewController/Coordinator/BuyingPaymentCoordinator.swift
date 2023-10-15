//
//  BuyingPaymentCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingPaymentCoordinator: AnyObject {

    func dismiss()
}

final class BuyingPaymentCoordinator: PresentationCoordinator, IBuyingPaymentCoordinator {

    private var coordinatorData: BuyingPaymentPassData { return castPassData(BuyingPaymentPassData.self) }
    
    private unowned var navController: MainNavigationController

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = BuyingPaymentBuilder.generate(with: coordinatorData, coordinator: self)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }
    
    func dismiss() {
        navController.dismiss(animated: true, completion: nil)
    }
}

extension BuyingPaymentCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> BuyingPaymentCoordinator {
        return BuyingPaymentCoordinator(presenterViewController: presenterViewController,
                                        navController: MainNavigationController())
    }
}
