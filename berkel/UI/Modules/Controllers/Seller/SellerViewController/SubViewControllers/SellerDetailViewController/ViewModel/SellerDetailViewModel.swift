//
//  SellerDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import Combine

protocol ISellerDetailViewModel: AnyObject {

    var viewState: ScreenStateSubject<SellerDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ISellerDetailRepository,
         coordinator: ISellerDetailCoordinator,
         uiModel: ISellerDetailUIModel)
}

final class SellerDetailViewModel: BaseViewModel, ISellerDetailViewModel {

    // MARK: Definitions
    private let repository: ISellerDetailRepository
    private let coordinator: ISellerDetailCoordinator
    private var uiModel: ISellerDetailUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<SellerDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ISellerDetailRepository,
                  coordinator: ISellerDetailCoordinator,
                  uiModel: ISellerDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension SellerDetailViewModel {

}

// MARK: States
internal extension SellerDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension SellerDetailViewModel {

}


enum SellerDetailViewState {
    case showNativeProgress(isProgress: Bool)
}
