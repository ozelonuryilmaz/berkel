//
//  NewBuyingViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol INewBuyingViewModel: AnyObject {
    
    var viewState: ScreenStateSubject<NewBuyingViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewBuyingRepository,
         coordinator: INewBuyingCoordinator,
         uiModel: INewBuyingUIModel)
    
    func initComponents()
    
    // Coordinator
    func dismiss()
}

final class NewBuyingViewModel: BaseViewModel, INewBuyingViewModel {

    // MARK: Definitions
    private let repository: INewBuyingRepository
    private let coordinator: INewBuyingCoordinator
    private var uiModel: INewBuyingUIModel

    // MARK: Private Props

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewBuyingViewState>(nil)
    var errorState = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: INewBuyingRepository,
                  coordinator: INewBuyingCoordinator,
                  uiModel: INewBuyingUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSellerName()
        self.viewStateSellerTCKN()
    }
}


// MARK: Service
internal extension NewBuyingViewModel {

}

// MARK: States
internal extension NewBuyingViewModel {

    // MARK: View State
    func viewStateSellerName() {
        self.viewState.value = .setSellerName(name: self.uiModel.sellerName)
    }
    
    func viewStateSellerTCKN() {
        self.viewState.value = .setSellerTCKN(tckn: self.uiModel.sellerTCKN)
    }

    // MARK: Action State

}

// MARK: Coordinate
internal extension NewBuyingViewModel {

    func dismiss() {
        self.coordinator.dismiss()
    }
}


enum NewBuyingViewState {
    
    case setSellerName(name: String)
    case setSellerTCKN(tckn: String)
}
