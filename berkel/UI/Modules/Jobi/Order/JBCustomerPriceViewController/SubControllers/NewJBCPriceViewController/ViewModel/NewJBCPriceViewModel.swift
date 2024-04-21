//
//  NewJBCPriceViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol INewJBCPriceViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewJBCPriceViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewJBCPriceRepository,
         coordinator: INewJBCPriceCoordinator,
         uiModel: INewJBCPriceUIModel)
    
    // Coordinate
    func dismiss()
}

final class NewJBCPriceViewModel: BaseViewModel, INewJBCPriceViewModel {

    // MARK: Definitions
    private let repository: INewJBCPriceRepository
    private let coordinator: INewJBCPriceCoordinator
    private var uiModel: INewJBCPriceUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<NewJBCPriceViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewJBCPriceRepository,
                  coordinator: INewJBCPriceCoordinator,
                  uiModel: INewJBCPriceUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension NewJBCPriceViewModel {

}

// MARK: States
internal extension NewJBCPriceViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension NewJBCPriceViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

enum NewJBCPriceViewState {
    case showNativeProgress(isProgress: Bool)
}
