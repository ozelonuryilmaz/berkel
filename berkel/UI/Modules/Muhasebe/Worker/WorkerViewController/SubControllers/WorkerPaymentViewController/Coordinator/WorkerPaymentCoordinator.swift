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

    override func start() {
        let controller = WorkerPaymentBuilder.generate(with: coordinatorData,
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
extension WorkerPaymentCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> WorkerPaymentCoordinator {
        return WorkerPaymentCoordinator(presenterViewController: presenterViewController)
    }
}
