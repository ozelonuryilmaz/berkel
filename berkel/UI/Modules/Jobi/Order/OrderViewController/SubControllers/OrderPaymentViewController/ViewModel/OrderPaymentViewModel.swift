//
//  OrderPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IOrderPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<OrderPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOrderPaymentRepository,
         coordinator: IOrderPaymentCoordinator,
         uiModel: IOrderPaymentUIModel)
    
    func initComponents()
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setPayment(_ text: String)
    func setDesc(_ text: String)

    // Service
    func savePayment()
}

final class OrderPaymentViewModel: BaseViewModel, IOrderPaymentViewModel {

    // MARK: Definitions
    private let repository: IOrderPaymentRepository
    private let coordinator: IOrderPaymentCoordinator
    private var uiModel: IOrderPaymentUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<OrderPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<OrderPaymentModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderPaymentRepository,
                  coordinator: IOrderPaymentCoordinator,
                  uiModel: IOrderPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateCustomerName()
    }
}


// MARK: Service
internal extension OrderPaymentViewModel {

    func savePayment() {
        guard self.uiModel.payment > 0 else { return }

        handleResourceFirestore(
            request: self.repository.savePayment(data: self.uiModel.data, 
                                                 season: self.uiModel.season),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.dismiss()
            })
    }
}

// MARK: States
internal extension OrderPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateCustomerName() {
        self.viewState.value = .setCustomerName(name: self.uiModel.customerName)
    }
}

// MARK: Coordinate
internal extension OrderPaymentViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension OrderPaymentViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setPayment(_ text: String) {
        self.uiModel.setPayment(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }
}

enum OrderPaymentViewState {
    case showNativeProgress(isProgress: Bool)
    case setCustomerName(name: String)
}
