//
//  CavusListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import Combine

protocol ICavusListViewModel: AnyObject {

    var viewState: ScreenStateSubject<CavusListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ICavusListRepository,
         coordinator: ICavusListCoordinator,
         uiModel: ICavusListUIModel)
    
    // Coordinate
    func presentNewCavusViewController()
}

final class CavusListViewModel: BaseViewModel, ICavusListViewModel {

    // MARK: Definitions
    private let repository: ICavusListRepository
    private let coordinator: ICavusListCoordinator
    private var uiModel: ICavusListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<CavusListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ICavusListRepository,
                  coordinator: ICavusListCoordinator,
                  uiModel: ICavusListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension CavusListViewModel {

}

// MARK: States
internal extension CavusListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension CavusListViewModel {

    func presentNewCavusViewController() {
        self.coordinator.presentNewCavusViewController(passData: NewCavusPassData())
    }
}


enum CavusListViewState {
    case showNativeProgress(isProgress: Bool)
}
