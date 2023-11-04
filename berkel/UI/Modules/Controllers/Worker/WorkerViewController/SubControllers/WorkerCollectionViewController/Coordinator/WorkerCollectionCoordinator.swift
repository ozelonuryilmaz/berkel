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

    private unowned var navController: MainNavigationController
    
    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = WorkerCollectionBuilder.generate(with: coordinatorData,
                                                                   coordinator: self)

        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

extension WorkerCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> WorkerCollectionCoordinator {
        return WorkerCollectionCoordinator(presenterViewController: presenterViewController,
                                                    navController: MainNavigationController())
    }
}
