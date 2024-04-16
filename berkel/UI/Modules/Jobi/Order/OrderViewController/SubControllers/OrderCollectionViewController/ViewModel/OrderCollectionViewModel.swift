//
//  OrderCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IOrderCollectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<OrderCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOrderCollectionRepository,
         coordinator: IOrderCollectionCoordinator,
         uiModel: IOrderCollectionUIModel)
}

final class OrderCollectionViewModel: BaseViewModel, IOrderCollectionViewModel {

    // MARK: Definitions
    private let repository: IOrderCollectionRepository
    private let coordinator: IOrderCollectionCoordinator
    private var uiModel: IOrderCollectionUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<OrderCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderCollectionRepository,
                  coordinator: IOrderCollectionCoordinator,
                  uiModel: IOrderCollectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension OrderCollectionViewModel {

}

// MARK: States
internal extension OrderCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension OrderCollectionViewModel {

}

enum OrderCollectionViewState {
    case showNativeProgress(isProgress: Bool)
}
