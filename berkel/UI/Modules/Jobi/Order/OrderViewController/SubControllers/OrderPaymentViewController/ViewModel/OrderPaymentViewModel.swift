//
//  OrderPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IOrderPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<OrderPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOrderPaymentRepository,
         coordinator: IOrderPaymentCoordinator,
         uiModel: IOrderPaymentUIModel)
    
    // Coordinate
    func dismiss()
}

final class OrderPaymentViewModel: BaseViewModel, IOrderPaymentViewModel {

    // MARK: Definitions
    private let repository: IOrderPaymentRepository
    private let coordinator: IOrderPaymentCoordinator
    private var uiModel: IOrderPaymentUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<OrderPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderPaymentRepository,
                  coordinator: IOrderPaymentCoordinator,
                  uiModel: IOrderPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension OrderPaymentViewModel {

}

// MARK: States
internal extension OrderPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension OrderPaymentViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

enum OrderPaymentViewState {
    case showNativeProgress(isProgress: Bool)
}
