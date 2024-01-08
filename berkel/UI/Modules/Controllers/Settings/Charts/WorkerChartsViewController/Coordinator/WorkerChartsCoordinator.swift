//
//  WorkerChartsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 8.01.2024.
//

import UIKit

protocol IWorkerChartsCoordinator: AnyObject {

}

final class WorkerChartsCoordinator: NavigationCoordinator, IWorkerChartsCoordinator {

    private var coordinatorData: WorkerChartsPassData { return castPassData(WorkerChartsPassData.self) }

    override func start() {
        let controller = WorkerChartsBuilder.generate(with: coordinatorData,
                                                      coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }

}
