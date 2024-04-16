//
//  JBCustomerListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IJBCustomerListViewModel: NewJBCustomerViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<JBCustomerListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJBCustomerListRepository,
         coordinator: IJBCustomerListCoordinator,
         uiModel: IJBCustomerListUIModel)
    
    // Coordinator
    func presentNewJBCustomerViewController()
}

final class JBCustomerListViewModel: BaseViewModel, IJBCustomerListViewModel {

    // MARK: Definitions
    private let repository: IJBCustomerListRepository
    private let coordinator: IJBCustomerListCoordinator
    private var uiModel: IJBCustomerListUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<JBCustomerListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IJBCustomerListRepository,
                  coordinator: IJBCustomerListCoordinator,
                  uiModel: IJBCustomerListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }
}


// MARK: Service
internal extension JBCustomerListViewModel {

}

// MARK: States
internal extension JBCustomerListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .playNativeLoading(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension JBCustomerListViewModel {

    func presentNewJBCustomerViewController() {
        self.coordinator.presentNewJBCustomerViewController(passData: NewJBCustomerPassData(),
                                                            outputDelegate: self)
    }
}

// MARK: NewJBCustomerViewControllerOutputDelegate
internal extension JBCustomerListViewModel {
    
    func newJBCustomerData(_ data: JBCustomerModel) {
        
    }
}

enum JBCustomerListViewState {
    case playNativeLoading(isProgress: Bool)
}
