//
//  BuyingDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IBuyingDetailViewModel: AnyObject {

    init(repository: IBuyingDetailRepository,
         coordinator: IBuyingDetailCoordinator,
         uiModel: IBuyingDetailUIModel)
}

final class BuyingDetailViewModel: BaseViewModel, IBuyingDetailViewModel {

    // MARK: Definitions
    private let repository: IBuyingDetailRepository
    private let coordinator: IBuyingDetailCoordinator
    private var uiModel: IBuyingDetailUIModel

    // MARK: Private Props

    // MARK: Public Props

    // MARK: Initiliazer
    required init(repository: IBuyingDetailRepository,
                  coordinator: IBuyingDetailCoordinator,
                  uiModel: IBuyingDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension BuyingDetailViewModel {

}

// MARK: States
internal extension BuyingDetailViewModel {

    // MARK: View State

}

// MARK: Coordinate
internal extension BuyingDetailViewModel {

}


enum BuyingDetailViewState {
    
}

