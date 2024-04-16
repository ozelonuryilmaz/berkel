//
//  NewOrderViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol INewOrderViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewOrderViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewOrderRepository,
         coordinator: INewOrderCoordinator,
         uiModel: INewOrderUIModel)
}

final class NewOrderViewModel: BaseViewModel, INewOrderViewModel {

    // MARK: Definitions
    private let repository: INewOrderRepository
    private let coordinator: INewOrderCoordinator
    private var uiModel: INewOrderUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<NewOrderViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewOrderRepository,
                  coordinator: INewOrderCoordinator,
                  uiModel: INewOrderUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension NewOrderViewModel {

}

// MARK: States
internal extension NewOrderViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension NewOrderViewModel {

}

enum NewOrderViewState {
    case showNativeProgress(isProgress: Bool)
}
