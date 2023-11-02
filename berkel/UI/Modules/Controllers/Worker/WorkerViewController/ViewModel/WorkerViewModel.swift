//
//  WorkerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Combine

protocol IWorkerViewModel: NewWorkerViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<WorkerViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IWorkerRepository,
         coordinator: IWorkerCoordinator,
         uiModel: IWorkerUIModel)
    
    func pushCavusListViewController()
}

final class WorkerViewModel: BaseViewModel, IWorkerViewModel {

    // MARK: Definitions
    private let repository: IWorkerRepository
    private let coordinator: IWorkerCoordinator
    private var uiModel: IWorkerUIModel

    var viewState = ScreenStateSubject<WorkerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<[NewBuyingModel]?, Never>(nil)

    var season: String {
        return uiModel.season
    }

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

    func pushCavusListViewController() {
        self.coordinator.pushCavusListViewController(passData: CavusListPassData(),
                                                     outputDelegate: self)
    }
}

// MARK: NewWorkerViewControllerOutputDelegate
internal extension WorkerViewModel {
    
    func newWorkerData(_ data: WorkerModel) {
        print("**** \(data)")
    }
}

enum WorkerViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum WorkerActionState {

}


