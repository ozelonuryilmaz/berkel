//
//  NewWorkerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import Combine

protocol INewWorkerViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewWorkerViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewWorkerRepository,
         coordinator: INewWorkerCoordinator,
         uiModel: INewWorkerUIModel)

    // Coordinate
    func dismiss()
}

final class NewWorkerViewModel: BaseViewModel, INewWorkerViewModel {

    // MARK: Definitions
    private let repository: INewWorkerRepository
    private let coordinator: INewWorkerCoordinator
    private var uiModel: INewWorkerUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewWorkerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewWorkerRepository,
                  coordinator: INewWorkerCoordinator,
                  uiModel: INewWorkerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension NewWorkerViewModel {

}

// MARK: States
internal extension NewWorkerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension NewWorkerViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum NewWorkerViewState {
    case showNativeProgress(isProgress: Bool)
}
