//
//  WorkerDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol IWorkerDetailCoordinator: AnyObject {

    func presentWorkerCollectionViewController(passData: WorkerCollectionPassData)
}

final class WorkerDetailCoordinator: NavigationCoordinator, IWorkerDetailCoordinator {

    private var coordinatorData: WorkerDetailPassData { return castPassData(WorkerDetailPassData.self) }

    private weak var outputDelegate: WorkerDetailViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: WorkerDetailViewControllerOutputDelegate) -> WorkerDetailCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = WorkerDetailBuilder.generate(with: coordinatorData,
                                                      coordinator: self,
                                                      outputDelegate: outputDelegate)

        navigationController.pushViewController(controller, animated: true)
    }

    func presentWorkerCollectionViewController(passData: WorkerCollectionPassData) {
        let controller = WorkerCollectionCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
