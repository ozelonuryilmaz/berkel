//
//  SellerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

protocol ISellerViewModel: NewSellerViewControllerOutputDelegate {

    var season: String { get }
    
    init(repository: ISellerRepository,
         coordinator: ISellerCoordinator,
         uiModel: ISellerUIModel)
    
    func pushCustomerListViewController()
}

final class SellerViewModel: BaseViewModel, ISellerViewModel {

    // MARK: Definitions
    private let repository: ISellerRepository
    private let coordinator: ISellerCoordinator
    private var uiModel: ISellerUIModel
    
    var season: String {
        return uiModel.season
    }

    // MARK: Initiliazer
    required init(repository: ISellerRepository,
                  coordinator: ISellerCoordinator,
                  uiModel: ISellerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension SellerViewModel {

}

// MARK: States
internal extension SellerViewModel {

    // MARK: View State
    // MARK: Action State

}

// MARK: Coordinate
internal extension SellerViewModel {

    func pushCustomerListViewController() {
        
        self.coordinator.pushCustomerListViewController(passData: CustomerListPassData(),
                                                        outputDelegate: self)
    }
}

// MARK: NewSellerViewControllerOutputDelegate
internal extension SellerViewModel {
    
    func newSellerData(_ data: SellerModel) {
        
    }
}

enum SellerViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum SellerActionState {

}


