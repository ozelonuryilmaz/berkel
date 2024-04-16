//
//  OrderDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IOrderDetailViewModel: AnyObject {

    var viewState: ScreenStateSubject<OrderDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOrderDetailRepository,
         coordinator: IOrderDetailCoordinator,
         uiModel: IOrderDetailUIModel)
}

final class OrderDetailViewModel: BaseViewModel, IOrderDetailViewModel {

    // MARK: Definitions
    private let repository: IOrderDetailRepository
    private let coordinator: IOrderDetailCoordinator
    private var uiModel: IOrderDetailUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<OrderDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderDetailRepository,
                  coordinator: IOrderDetailCoordinator,
                  uiModel: IOrderDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension OrderDetailViewModel {

}

// MARK: States
internal extension OrderDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension OrderDetailViewModel {

}

enum OrderDetailViewState {
    case showNativeProgress(isProgress: Bool)
}
