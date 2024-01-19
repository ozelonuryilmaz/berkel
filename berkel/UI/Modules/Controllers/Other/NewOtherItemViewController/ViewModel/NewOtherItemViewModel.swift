//
//  NewOtherItemViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol INewOtherItemViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewOtherItemViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewOtherItemRepository,
         coordinator: INewOtherItemCoordinator,
         uiModel: INewOtherItemUIModel)

    func initComponents()
    
    // Coordinate
    func dismiss(completion: (() -> Void)?)
}

final class NewOtherItemViewModel: BaseViewModel, INewOtherItemViewModel {

    // MARK: Definitions
    private let repository: INewOtherItemRepository
    private let coordinator: INewOtherItemCoordinator
    private var uiModel: INewOtherItemUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewOtherItemViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewOtherItemRepository,
                  coordinator: INewOtherItemCoordinator,
                  uiModel: INewOtherItemUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {

    }
}


// MARK: Service
internal extension NewOtherItemViewModel {

}

// MARK: States
internal extension NewOtherItemViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateOutputDelegate(otherModel: OtherModel) {
        self.viewState.value = .outputDelegate(otherModel: otherModel)
    }

}

// MARK: Coordinate
internal extension NewOtherItemViewModel {

    func dismiss(completion: (() -> Void)?) {
        self.coordinator.dismiss(completion: completion)
    }
}


enum NewOtherItemViewState {
    case showNativeProgress(isProgress: Bool)
    case outputDelegate(otherModel: OtherModel)
}
