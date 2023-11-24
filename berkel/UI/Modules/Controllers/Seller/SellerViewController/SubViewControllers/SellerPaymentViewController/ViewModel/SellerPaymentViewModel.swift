//
//  SellerPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import Combine

protocol ISellerPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<SellerPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ISellerPaymentRepository,
         coordinator: ISellerPaymentCoordinator,
         uiModel: ISellerPaymentUIModel)
    
    func dismiss()
}

final class SellerPaymentViewModel: BaseViewModel, ISellerPaymentViewModel {

    // MARK: Definitions
    private let repository: ISellerPaymentRepository
    private let coordinator: ISellerPaymentCoordinator
    private var uiModel: ISellerPaymentUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<SellerPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ISellerPaymentRepository,
                  coordinator: ISellerPaymentCoordinator,
                  uiModel: ISellerPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension SellerPaymentViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: States
internal extension SellerPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension SellerPaymentViewModel {

}


enum SellerPaymentViewState {
    case showNativeProgress(isProgress: Bool)
}
