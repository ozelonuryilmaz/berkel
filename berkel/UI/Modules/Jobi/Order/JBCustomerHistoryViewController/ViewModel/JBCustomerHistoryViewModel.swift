//
//  JBCustomerHistoryViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IJBCustomerHistoryViewModel: AnyObject {

    var viewState: ScreenStateSubject<JBCustomerHistoryViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJBCustomerHistoryRepository,
         coordinator: IJBCustomerHistoryCoordinator,
         uiModel: IJBCustomerHistoryUIModel)
    
    var customerName: String { get }
}

final class JBCustomerHistoryViewModel: BaseViewModel, IJBCustomerHistoryViewModel {

    // MARK: Definitions
    private let repository: IJBCustomerHistoryRepository
    private let coordinator: IJBCustomerHistoryCoordinator
    private var uiModel: IJBCustomerHistoryUIModel

    // MARK: Private Props
    let viewState = ScreenStateSubject<JBCustomerHistoryViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IJBCustomerHistoryRepository,
                  coordinator: IJBCustomerHistoryCoordinator,
                  uiModel: IJBCustomerHistoryUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var customerName: String {
        return uiModel.customerName
    }
}


// MARK: Service
internal extension JBCustomerHistoryViewModel {

}

// MARK: States
internal extension JBCustomerHistoryViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension JBCustomerHistoryViewModel {

}

enum JBCustomerHistoryViewState {
    case showNativeProgress(isProgress: Bool)
}
