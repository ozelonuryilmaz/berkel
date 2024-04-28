//
//  OrderCollectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IOrderCollectionViewModel: JBCustomerPriceViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<OrderCollectionViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOrderCollectionRepository,
         coordinator: IOrderCollectionCoordinator,
         uiModel: IOrderCollectionUIModel)

    // Init
    func initComponents()

    // Coordinate
    func presentJBCustomerPriceViewController()
    func dismiss()

    // Setter
    func setCount(_ count: String)
    func setKDV(_ kdv: String)
    func setDesc(_ desc: String)
}

final class OrderCollectionViewModel: BaseViewModel, IOrderCollectionViewModel {

    // MARK: Definitions
    private let repository: IOrderCollectionRepository
    private let coordinator: IOrderCollectionCoordinator
    private var uiModel: IOrderCollectionUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<OrderCollectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderCollectionRepository,
                  coordinator: IOrderCollectionCoordinator,
                  uiModel: IOrderCollectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSetCustomerName()
    }

    func setCount(_ count: String) {
        self.uiModel.setCount(count)
    }

    func setKDV(_ kdv: String) {
        self.uiModel.setKDV(kdv)
    }

    func setDesc(_ desc: String) {
        self.uiModel.setDesc(desc)
    }
}


// MARK: Service
internal extension OrderCollectionViewModel {

}

// MARK: States
internal extension OrderCollectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetCustomerName() {
        viewState.value = .setCustomerName(name: uiModel.customerName)
    }

    func viewStateSetProductName() {
        viewState.value = .setProductName(name: uiModel.productName)
    }

    func viewStateSetPrice() {
        viewState.value = .setPrice(price: uiModel.productPrice)
    }
}

// MARK: Coordinate
internal extension OrderCollectionViewModel {
    
    func presentJBCustomerPriceViewController() {
        let passData = JBCustomerPricePassData(isPriceSelectable: true,
                                               customerModel: JBCustomerModel(id: uiModel.customerId,
                                                                              name: uiModel.customerName,
                                                                              phoneNumber: "",
                                                                              description: nil,
                                                                              date: nil))

        self.coordinator.presentJBCustomerPriceViewController(passData: passData,
                                                              outputDelegate: self)
    }

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: JBCustomerPriceViewControllerOutputDelegate
internal extension OrderCollectionViewModel {

    func getJBCProductAndPrice(stockModel: StockModel, subStockModel: SubStockModel, price: Double) {
        self.uiModel.setStockModel(stockModel)
        self.uiModel.setSubStockModel(subStockModel)
        self.uiModel.setPrice(price)

        self.viewStateSetProductName()
        self.viewStateSetPrice()
    }
}

enum OrderCollectionViewState {
    case showNativeProgress(isProgress: Bool)
    case setCustomerName(name: String)
    case setProductName(name: String)
    case setPrice(price: String)
}
