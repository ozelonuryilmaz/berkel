//
//  AddBuyingItemViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IAddBuyingItemViewModel: AnyObject {

    init(repository: IAddBuyingItemRepository,
         coordinator: IAddBuyingItemCoordinator,
         uiModel: IAddBuyingItemUIModel)
    
    // Coordinator
    func presentAddSellerViewController()
}

final class AddBuyingItemViewModel: BaseViewModel, IAddBuyingItemViewModel {

    // MARK: Definitions
    private let repository: IAddBuyingItemRepository
    private let coordinator: IAddBuyingItemCoordinator
    private var uiModel: IAddBuyingItemUIModel

    // MARK: Private Props

    // MARK: Public Props

    // MARK: Initiliazer
    required init(repository: IAddBuyingItemRepository,
                  coordinator: IAddBuyingItemCoordinator,
                  uiModel: IAddBuyingItemUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension AddBuyingItemViewModel {

}

// MARK: States
internal extension AddBuyingItemViewModel {

    // MARK: View State
    func viewStateShowProgressLoading(isProgress: Bool) {

    }

    // MARK: Action State

}

// MARK: Coordinate
internal extension AddBuyingItemViewModel {

    func presentAddSellerViewController() {
        self.coordinator.presentAddSellerViewController()
    }
}


enum AddBuyingItemViewState {
    case showLoadingProgress(isProgress: Bool)
}
