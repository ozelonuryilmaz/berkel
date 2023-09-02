//
//  WorkerBuilder.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
// 

import UIKit

enum WorkerBuilder {
    
    static func generate(coordinator: IWorkerCoordinator) -> WorkerViewController {
        let repository = WorkerRepository()
        let uiModel = WorkerUIModel()
        let viewModel = WorkerViewModel(repository: repository, 
                                                           coordinator: coordinator,
                                                           uiModel: uiModel)
        return WorkerViewController(viewModel: viewModel)
    }
}
