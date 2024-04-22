//
//  JBCPriceViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IJBCPriceViewModel: NewJBCPriceViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<JBCPriceViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJBCPriceRepository,
         coordinator: IJBCPriceCoordinator,
         uiModel: IJBCPriceUIModel)
    
    var navTitle: String { get }
    
    // Coordinator
    func presentNewJBCPriceViewController()
}

final class JBCPriceViewModel: BaseViewModel, IJBCPriceViewModel {

    // MARK: Definitions
    private let repository: IJBCPriceRepository
    private let coordinator: IJBCPriceCoordinator
    private var uiModel: IJBCPriceUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<JBCPriceViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IJBCPriceRepository,
                  coordinator: IJBCPriceCoordinator,
                  uiModel: IJBCPriceUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var navTitle: String {
        return uiModel.navTitle
    }
}


// MARK: Service
internal extension JBCPriceViewModel {

}

// MARK: States
internal extension JBCPriceViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension JBCPriceViewModel {

    func presentNewJBCPriceViewController() {
        self.coordinator.presentNewJBCPriceCiewController(passData: self.uiModel.newJBCPricePassData,
                                                          outputDelegate: self)
    }
}

// MARK: NewJBCPriceViewControllerOutputDelegate
internal extension JBCPriceViewModel {
    
    func newJBCPriceData(_ data: JBCPriceModel) {
        
    }
}

enum JBCPriceViewState {
    case showNativeProgress(isProgress: Bool)
}
