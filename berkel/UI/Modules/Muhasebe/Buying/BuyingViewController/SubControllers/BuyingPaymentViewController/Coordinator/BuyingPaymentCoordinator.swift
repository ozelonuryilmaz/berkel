//
//  BuyingPaymentCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//

import UIKit

protocol IBuyingPaymentCoordinator: AnyObject {

    func dismiss()
}

final class BuyingPaymentCoordinator: PresentationCoordinator, IBuyingPaymentCoordinator {

    private var coordinatorData: BuyingPaymentPassData { return castPassData(BuyingPaymentPassData.self) }

    override func start() {
        let controller = BuyingPaymentBuilder.generate(with: coordinatorData, coordinator: self)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }
    
    func dismiss() {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension BuyingPaymentCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> BuyingPaymentCoordinator {
        return BuyingPaymentCoordinator(presenterViewController: presenterViewController)
    }
}
