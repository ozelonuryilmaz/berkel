//
//  WorkerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol IWorkerCoordinator: AnyObject {

    func pushCavusListViewController(passData: CavusListPassData,
                                     outputDelegate: NewWorkerViewControllerOutputDelegate)

    func pushWorkerDetailViewController(passData: WorkerDetailPassData,
                                        outputDelegate: WorkerDetailViewControllerOutputDelegate)
    func presentWorkerCollectionViewController(passData: WorkerCollectionPassData)
    func presentWorkerPaymentViewController(passData: WorkerPaymentPassData)
}

final class WorkerCoordinator: NavigationCoordinator, IWorkerCoordinator {

    private var coordinatorData: WorkerPassData { return castPassData(WorkerPassData.self) }

    override func start() {
        let controller = WorkerBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

    func pushCavusListViewController(passData: CavusListPassData,
                                     outputDelegate: NewWorkerViewControllerOutputDelegate) {
        let coordinator = CavusListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func pushWorkerDetailViewController(passData: WorkerDetailPassData,
                                        outputDelegate: WorkerDetailViewControllerOutputDelegate) {
        let coordinator = WorkerDetailCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }

    func presentWorkerCollectionViewController(passData: WorkerCollectionPassData) {
        let controller = WorkerCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }

    func presentWorkerPaymentViewController(passData: WorkerPaymentPassData) {
        let controller = WorkerPaymentCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
