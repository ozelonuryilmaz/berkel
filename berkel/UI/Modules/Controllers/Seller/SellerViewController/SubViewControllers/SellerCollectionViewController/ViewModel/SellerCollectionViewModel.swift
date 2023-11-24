//
//  SellerCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import Combine

protocol ISellerCollectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<SellerCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ISellerCollectionRepository,
         coordinator: ISellerCollectionCoordinator,
         uiModel: ISellerCollectionUIModel)
    
    func dismiss()
}

final class SellerCollectionViewModel: BaseViewModel, ISellerCollectionViewModel {

    // MARK: Definitions
    private let repository: ISellerCollectionRepository
    private let coordinator: ISellerCollectionCoordinator
    private var uiModel: ISellerCollectionUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<SellerCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ISellerCollectionRepository,
                  coordinator: ISellerCollectionCoordinator,
                  uiModel: ISellerCollectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension SellerCollectionViewModel {

}

// MARK: States
internal extension SellerCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension SellerCollectionViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum SellerCollectionViewState {
    case showNativeProgress(isProgress: Bool)
}
