//
//  EmptyAuthViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.03.2024.
//

import Combine

protocol IEmptyAuthViewModel: AnyObject {

    var viewState: ScreenStateSubject<EmptyAuthViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IEmptyAuthRepository,
         coordinator: IEmptyAuthCoordinator,
         uiModel: IEmptyAuthUIModel)
}

final class EmptyAuthViewModel: BaseViewModel, IEmptyAuthViewModel {

    // MARK: Definitions
    private let repository: IEmptyAuthRepository
    private let coordinator: IEmptyAuthCoordinator
    private var uiModel: IEmptyAuthUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<EmptyAuthViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IEmptyAuthRepository,
                  coordinator: IEmptyAuthCoordinator,
                  uiModel: IEmptyAuthUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension EmptyAuthViewModel {

}

// MARK: States
internal extension EmptyAuthViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension EmptyAuthViewModel {

}


enum EmptyAuthViewState {
    case showNativeProgress(isProgress: Bool)
}
