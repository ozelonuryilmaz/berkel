//
//  OtherPaymentCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import UIKit

protocol IOtherPaymentCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class OtherPaymentCoordinator: PresentationCoordinator, IOtherPaymentCoordinator {

    private var coordinatorData: OtherPaymentPassData { return castPassData(OtherPaymentPassData.self) }

    override func start() {
        let controller = OtherPaymentBuilder.generate(with: coordinatorData,
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
extension OtherPaymentCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> OtherPaymentCoordinator {
        return OtherPaymentCoordinator(presenterViewController: presenterViewController)
    }
}
