//
//  OrderViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Combine

protocol IOrderViewModel: JBCustomerListViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<OrderViewState> { get }
    var errorState: ErrorStateSubject { get }
    
    var season: String { get }

    init(repository: IOrderRepository,
         coordinator: IOrderCoordinator,
         uiModel: IOrderUIModel)
    
    // Coordinator
    func pushJBCustomerListViewController()
}

final class OrderViewModel: BaseViewModel, IOrderViewModel {

    // MARK: Definitions
    private let repository: IOrderRepository
    private let coordinator: IOrderCoordinator
    private var uiModel: IOrderUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OrderViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderRepository,
                  coordinator: IOrderCoordinator,
                  uiModel: IOrderUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var season: String {
        return uiModel.season
    }
}


// MARK: Service
internal extension OrderViewModel {

}

// MARK: States
internal extension OrderViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension OrderViewModel {

    func pushJBCustomerListViewController() {
        self.coordinator.pushJBCustomerListViewController(passData: JBCustomerListPassData(),
                                                          outputDelegate: self)
    }
}

// MARK: JBCustomerListViewControllerOutputDelegate
internal extension OrderViewModel {

    func newOrderData(_ data: OrderModel) {
        
    }
}

enum OrderViewState {
    case showNativeProgress(isProgress: Bool)
}
