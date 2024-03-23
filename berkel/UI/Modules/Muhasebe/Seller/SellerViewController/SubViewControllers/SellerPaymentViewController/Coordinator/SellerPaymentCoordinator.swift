//
//  SellerPaymentCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import UIKit

protocol ISellerPaymentCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class SellerPaymentCoordinator: PresentationCoordinator, ISellerPaymentCoordinator {

    private var coordinatorData: SellerPaymentPassData { return castPassData(SellerPaymentPassData.self) }

    override func start() {
        let controller = SellerPaymentBuilder.generate(with: coordinatorData,
                                                       coordinator: self)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension SellerPaymentCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> SellerPaymentCoordinator {
        return SellerPaymentCoordinator(presenterViewController: presenterViewController)
    }
}
