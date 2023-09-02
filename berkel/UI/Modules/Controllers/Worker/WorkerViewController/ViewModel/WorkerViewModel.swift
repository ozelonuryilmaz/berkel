//
//  WorkerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IWorkerViewModel: AnyObject {

    init(repository: IWorkerRepository,
         coordinator: IWorkerCoordinator,
         uiModel: IWorkerUIModel)
}

final class WorkerViewModel: BaseViewModel, IWorkerViewModel {

    // MARK: Definitions
    private let repository: IWorkerRepository
    private let coordinator: IWorkerCoordinator
    private var uiModel: IWorkerUIModel

    // MARK: Initiliazer
    required init(repository: IWorkerRepository,
                  coordinator: IWorkerCoordinator,
                  uiModel: IWorkerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension WorkerViewModel {

}

// MARK: States
internal extension WorkerViewModel {

    // MARK: View State
    // MARK: Action State

}

// MARK: Coordinate
internal extension WorkerViewModel {

}


enum WorkerViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum WorkerActionState {

}


