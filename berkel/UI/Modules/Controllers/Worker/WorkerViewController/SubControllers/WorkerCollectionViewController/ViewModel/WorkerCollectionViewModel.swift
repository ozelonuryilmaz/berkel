//
//  WorkerCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Combine

protocol IWorkerCollectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<WorkerCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IWorkerCollectionRepository,
         coordinator: IWorkerCollectionCoordinator,
         uiModel: IWorkerCollectionUIModel)

    func dismiss()
}

final class WorkerCollectionViewModel: BaseViewModel, IWorkerCollectionViewModel {

    // MARK: Definitions
    private let repository: IWorkerCollectionRepository
    private let coordinator: IWorkerCollectionCoordinator
    private var uiModel: IWorkerCollectionUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<WorkerCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IWorkerCollectionRepository,
                  coordinator: IWorkerCollectionCoordinator,
                  uiModel: IWorkerCollectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension WorkerCollectionViewModel {

}

// MARK: States
internal extension WorkerCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension WorkerCollectionViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum WorkerCollectionViewState {
    case showNativeProgress(isProgress: Bool)
}
