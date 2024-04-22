//
//  NewOrderViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol INewOrderViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewOrderViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewOrderRepository,
         coordinator: INewOrderCoordinator,
         uiModel: INewOrderUIModel)
    
    func initComponents()
    
    // Service
    func saveNewOrder()
    
    // Coordinate
    func dismiss(completion: (() -> Void)?)
    
    // Setter
    func setDesc(_ value: String)
}

final class NewOrderViewModel: BaseViewModel, INewOrderViewModel {

    // MARK: Definitions
    private let repository: INewOrderRepository
    private let coordinator: INewOrderCoordinator
    private var uiModel: INewOrderUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<NewOrderViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseOrder = CurrentValueSubject<OrderModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewOrderRepository,
                  coordinator: INewOrderCoordinator,
                  uiModel: INewOrderUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }
    
    func initComponents() {
        self.viewStateSetJBCustomerName()
    }
}

// MARK: Service
internal extension NewOrderViewModel {

    func saveNewOrder() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewOrder(data: self.uiModel.newOrderData,
                                                  season: self.uiModel.season),
            response: self.responseOrder,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let response = self.responseOrder.value else { return }
                self.dismiss(completion: {
                    self.viewStateOutputDelegate(orderModel: response)
                })
            })
    }
}

// MARK: States
internal extension NewOrderViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateOutputDelegate(orderModel: OrderModel) {
        self.viewState.value = .outputDelegate(orderModel: orderModel)
    }

    func viewStateSetJBCustomerName() {
        self.viewState.value = .setJBCustomerName(name: self.uiModel.jbCustomerName)
    }
}

// MARK: Coordinate
internal extension NewOrderViewModel {

    func dismiss(completion: (() -> Void)?) {
        self.coordinator.dismiss(completion: completion)
    }
}

// MARK: Setter
internal extension NewOrderViewModel {

    func setDesc(_ value: String) {
        self.uiModel.setDesc(value)
    }
}

enum NewOrderViewState {
    case showNativeProgress(isProgress: Bool)
    case outputDelegate(orderModel: OrderModel)
    case setJBCustomerName(name: String)
}
