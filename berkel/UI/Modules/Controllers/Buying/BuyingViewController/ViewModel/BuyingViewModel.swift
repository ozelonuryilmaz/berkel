//
//  BuyingViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IBuyingViewModel: AnyObject {

    init(repository: IBuyingRepository,
         coordinator: IBuyingCoordinator,
         uiModel: IBuyingUIModel)
}

final class BuyingViewModel: BaseViewModel, IBuyingViewModel {

    // MARK: Definitions
    private let repository: IBuyingRepository
    private let coordinator: IBuyingCoordinator
    private var uiModel: IBuyingUIModel

    // MARK: Initiliazer
    required init(repository: IBuyingRepository,
                  coordinator: IBuyingCoordinator,
                  uiModel: IBuyingUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension BuyingViewModel {

}

// MARK: States
internal extension BuyingViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension BuyingViewModel {

}


enum BuyingViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum BuyingActionState {

}


