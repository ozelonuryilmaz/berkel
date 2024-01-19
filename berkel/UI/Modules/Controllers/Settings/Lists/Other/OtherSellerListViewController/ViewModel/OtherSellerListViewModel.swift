//
//  OtherSellerListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol IOtherSellerListViewModel: NewOtherItemViewControllerOutputDelegate, NewOtherSellerViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<OtherSellerListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOtherSellerListRepository,
         coordinator: IOtherSellerListCoordinator,
         uiModel: IOtherSellerListUIModel)

    // Coordinator
    func presentNewOtherSellerViewController(passData: NewOtherSellerPassData)
}

final class OtherSellerListViewModel: BaseViewModel, IOtherSellerListViewModel {

    // MARK: Definitions
    private let repository: IOtherSellerListRepository
    private let coordinator: IOtherSellerListCoordinator
    private var uiModel: IOtherSellerListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherSellerListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOtherSellerListRepository,
                  coordinator: IOtherSellerListCoordinator,
                  uiModel: IOtherSellerListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension OtherSellerListViewModel {

}

// MARK: States
internal extension OtherSellerListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension OtherSellerListViewModel {

    func presentNewOtherSellerViewController(passData: NewOtherSellerPassData) {
        self.coordinator.presentNewOtherSellerViewController(passData: passData,
                                                             outputDelegate: self)
    }

    func presentNewOtherItemViewController(passData: NewOtherItemPassData) {
        self.coordinator.presentNewOtherItemViewController(passData: passData,
                                                           outputDelegate: self)
    }
}

// MARK: NewOtherSellerViewControllerOutputDelegate
internal extension OtherSellerListViewModel {

    func otherSellerData(_ data: OtherSellerModel) {

    }
}

// MARK: NewOtherItemViewControllerOutputDelegate
internal extension OtherSellerListViewModel {

    func newOtherItemData(_ data: OtherModel) {

    }
}

enum OtherSellerListViewState {
    case showNativeProgress(isProgress: Bool)
}
