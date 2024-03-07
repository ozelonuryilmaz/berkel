//
//  CostViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Combine

protocol ICostViewModel: AnyObject {

    var viewState: ScreenStateSubject<CostViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ICostRepository,
         coordinator: ICostCoordinator,
         uiModel: ICostUIModel)
}

final class CostViewModel: BaseViewModel, ICostViewModel {

    // MARK: Definitions
    private let repository: ICostRepository
    private let coordinator: ICostCoordinator
    private var uiModel: ICostUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<CostViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ICostRepository,
                  coordinator: ICostCoordinator,
                  uiModel: ICostUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension CostViewModel {

}

// MARK: States
internal extension CostViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension CostViewModel {

}


enum CostViewState {
    case showNativeProgress(isProgress: Bool)
}
