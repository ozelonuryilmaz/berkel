//
//  NewOtherSellerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol INewOtherSellerViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewOtherSellerViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewOtherSellerRepository,
         coordinator: INewOtherSellerCoordinator,
         uiModel: INewOtherSellerUIModel)
    
    // Coordinate
    func dismiss()
}

final class NewOtherSellerViewModel: BaseViewModel, INewOtherSellerViewModel {

    // MARK: Definitions
    private let repository: INewOtherSellerRepository
    private let coordinator: INewOtherSellerCoordinator
    private var uiModel: INewOtherSellerUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewOtherSellerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewOtherSellerRepository,
                  coordinator: INewOtherSellerCoordinator,
                  uiModel: INewOtherSellerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension NewOtherSellerViewModel {

}

// MARK: States
internal extension NewOtherSellerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension NewOtherSellerViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum NewOtherSellerViewState {
    case showNativeProgress(isProgress: Bool)
}
