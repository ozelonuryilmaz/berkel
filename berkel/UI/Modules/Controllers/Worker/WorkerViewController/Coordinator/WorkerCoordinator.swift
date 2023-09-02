//
//  WorkerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IWorkerCoordinator: AnyObject {
    
}

final class WorkerCoordinator: NavigationCoordinator , IWorkerCoordinator {

    private var coordinatorData: WorkerPassData { return castPassData(WorkerPassData.self) }

     override func start() {
        let controller = WorkerBuilder.generate(coordinator: self)
         navigationController.viewControllers = [controller]
     }
}
