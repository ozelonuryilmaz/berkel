//
//  WorkerPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import Combine

protocol IWorkerPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<WorkerPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IWorkerPaymentRepository,
         coordinator: IWorkerPaymentCoordinator,
         uiModel: IWorkerPaymentUIModel)
    
    func dismiss()
}

final class WorkerPaymentViewModel: BaseViewModel, IWorkerPaymentViewModel {

    // MARK: Definitions
    private let repository: IWorkerPaymentRepository
    private let coordinator: IWorkerPaymentCoordinator
    private var uiModel: IWorkerPaymentUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<WorkerPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IWorkerPaymentRepository,
                  coordinator: IWorkerPaymentCoordinator,
                  uiModel: IWorkerPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension WorkerPaymentViewModel {

}

// MARK: States
internal extension WorkerPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension WorkerPaymentViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum WorkerPaymentViewState {
    case showNativeProgress(isProgress: Bool)
}
