//
//  WorkerPaymentCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol IWorkerPaymentCoordinator: AnyObject {
    func dismiss(completion: (() -> Void)?)
}

final class WorkerPaymentCoordinator: PresentationCoordinator, IWorkerPaymentCoordinator {

    private var coordinatorData: WorkerPaymentPassData { return castPassData(WorkerPaymentPassData.self) }

    private unowned var navController: MainNavigationController

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }
    
    override func start() {
        let controller = WorkerPaymentBuilder.generate(with: coordinatorData,
                                                                   coordinator: self)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension WorkerPaymentCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> WorkerPaymentCoordinator {
        return WorkerPaymentCoordinator(presenterViewController: presenterViewController,
                                                    navController: MainNavigationController())
    }
}
