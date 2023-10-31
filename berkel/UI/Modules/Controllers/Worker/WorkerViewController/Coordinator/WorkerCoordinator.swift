//
//  WorkerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

protocol IWorkerCoordinator: AnyObject {

    func pushCavusListViewController(passData: CavusListPassData)
}

final class WorkerCoordinator: NavigationCoordinator, IWorkerCoordinator {

    private var coordinatorData: WorkerPassData { return castPassData(WorkerPassData.self) }

    override func start() {
        let controller = WorkerBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

    func pushCavusListViewController(passData: CavusListPassData) {
        let coordinator = CavusListCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
}
