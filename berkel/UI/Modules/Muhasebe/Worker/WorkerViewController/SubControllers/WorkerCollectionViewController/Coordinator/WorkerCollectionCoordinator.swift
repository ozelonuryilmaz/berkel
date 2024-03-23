//
//  WorkerCollectionCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol IWorkerCollectionCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class WorkerCollectionCoordinator: PresentationCoordinator, IWorkerCollectionCoordinator {

    private var coordinatorData: WorkerCollectionPassData { return castPassData(WorkerCollectionPassData.self) }

    override func start() {
        let controller = WorkerCollectionBuilder.generate(with: coordinatorData,
                                                          coordinator: self)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}

extension WorkerCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> WorkerCollectionCoordinator {
        return WorkerCollectionCoordinator(presenterViewController: presenterViewController)
    }
}
