//
//  JobiListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Combine

protocol IJobiListViewModel: AnyObject {

    var viewState: ScreenStateSubject<JobiListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJobiListRepository,
         coordinator: IJobiListCoordinator,
         uiModel: IJobiListUIModel)
}

final class JobiListViewModel: BaseViewModel, IJobiListViewModel {

    // MARK: Definitions
    private let repository: IJobiListRepository
    private let coordinator: IJobiListCoordinator
    private var uiModel: IJobiListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<JobiListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IJobiListRepository,
                  coordinator: IJobiListCoordinator,
                  uiModel: IJobiListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension JobiListViewModel {

}

// MARK: States
internal extension JobiListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension JobiListViewModel {

}


enum JobiListViewState {
    case showNativeProgress(isProgress: Bool)
}
