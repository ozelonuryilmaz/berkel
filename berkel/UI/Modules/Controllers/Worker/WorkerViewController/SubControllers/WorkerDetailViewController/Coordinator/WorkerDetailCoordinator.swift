//
//  WorkerDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol IWorkerDetailCoordinator: AnyObject {

}

final class WorkerDetailCoordinator: NavigationCoordinator, IWorkerDetailCoordinator {

    private var coordinatorData: WorkerDetailPassData { return castPassData(WorkerDetailPassData.self) }

    override func start() {
        let controller = WorkerDetailBuilder.generate(with: coordinatorData,
                                                      coordinator: self)

        navigationController.pushViewController(controller, animated: true)
    }
}
