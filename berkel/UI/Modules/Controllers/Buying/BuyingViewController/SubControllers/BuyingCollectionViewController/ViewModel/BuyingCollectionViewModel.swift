//
//  BuyingCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IBuyingCollectionViewModel: AnyObject {

    init(repository: IBuyingCollectionRepository,
         coordinator: IBuyingCollectionCoordinator,
         uiModel: IBuyingCollectionUIModel,
         successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?)
    func initComponents()
    func dismiss()
}

final class BuyingCollectionViewModel: BaseViewModel, IBuyingCollectionViewModel {

    // MARK: Definitions
    private let repository: IBuyingCollectionRepository
    private let coordinator: IBuyingCollectionCoordinator
    private var uiModel: IBuyingCollectionUIModel
    var successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)? = nil

    // MARK: Private Props


    // MARK: Public Props


    // MARK: Initiliazer
    required init(repository: IBuyingCollectionRepository,
                  coordinator: IBuyingCollectionCoordinator,
                  uiModel: IBuyingCollectionUIModel,
                  successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.successDismissCallBack = successDismissCallBack
    }
    
    func initComponents() {
        
    }

}


// MARK: Service
internal extension BuyingCollectionViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }

    func successDismiss(data: BuyingCollectionModel) {
        self.coordinator.dismiss(completion: { [weak self] in
            self?.successDismissCallBack?(data)
        })
    }
}

// MARK: States
internal extension BuyingCollectionViewModel {

    // MARK: View State


    // MARK: Action State

}

// MARK: Coordinate
internal extension BuyingCollectionViewModel {

}


enum BuyingCollectionViewState {
    case showLoadingProgress(isProgress: Bool)
}
