//
//  WorkerDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Combine

protocol IWorkerDetailViewModel: AnyObject {

    var viewState: ScreenStateSubject<WorkerDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IWorkerDetailRepository,
         coordinator: IWorkerDetailCoordinator,
         uiModel: IWorkerDetailUIModel)
}

final class WorkerDetailViewModel: BaseViewModel, IWorkerDetailViewModel {

    // MARK: Definitions
    private let repository: IWorkerDetailRepository
    private let coordinator: IWorkerDetailCoordinator
    private var uiModel: IWorkerDetailUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<WorkerDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IWorkerDetailRepository,
                  coordinator: IWorkerDetailCoordinator,
                  uiModel: IWorkerDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension WorkerDetailViewModel {

}

// MARK: States
internal extension WorkerDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension WorkerDetailViewModel {

}


enum WorkerDetailViewState {
    case showNativeProgress(isProgress: Bool)
}
