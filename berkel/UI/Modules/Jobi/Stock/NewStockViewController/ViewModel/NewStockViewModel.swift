//
//  NewStockViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Combine

protocol INewStockViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewStockViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewStockRepository,
         coordinator: INewStockCoordinator,
         uiModel: INewStockUIModel)
}

final class NewStockViewModel: BaseViewModel, INewStockViewModel {

    // MARK: Definitions
    private let repository: INewStockRepository
    private let coordinator: INewStockCoordinator
    private var uiModel: INewStockUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewStockViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewStockRepository,
                  coordinator: INewStockCoordinator,
                  uiModel: INewStockUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension NewStockViewModel {

}

// MARK: States
internal extension NewStockViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension NewStockViewModel {

}


enum NewStockViewState {
    case showNativeProgress(isProgress: Bool)
}
