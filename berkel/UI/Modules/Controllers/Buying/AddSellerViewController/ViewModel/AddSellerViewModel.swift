//
//  AddSellerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IAddSellerViewModel: AnyObject {
    
    init(repository: IAddSellerRepository,
         coordinator: IAddSellerCoordinator,
         uiModel: IAddSellerUIModel)
    
    // Coordinator
    func dismiss()
}

final class AddSellerViewModel: BaseViewModel, IAddSellerViewModel {

    // MARK: Definitions
    private let repository: IAddSellerRepository
    private let coordinator: IAddSellerCoordinator
    private var uiModel: IAddSellerUIModel

    // MARK: Private Props

    // MARK: Public Props

    // MARK: Initiliazer
    required init(repository: IAddSellerRepository,
                  coordinator: IAddSellerCoordinator,
                  uiModel: IAddSellerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension AddSellerViewModel {

}

// MARK: States
internal extension AddSellerViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension AddSellerViewModel {

    func dismiss() {
        self.coordinator.dismiss()
    }
}


enum AddSellerViewState {
    case showLoadingProgress(isProgress: Bool)
}


