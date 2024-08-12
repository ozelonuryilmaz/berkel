//
//  JBCPriceViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IJBCPriceViewModel: NewJBCPriceViewControllerOutputDelegate,
                                JBCPriceItemCellOutputDelegate {

    var viewState: ScreenStateSubject<JBCPriceViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJBCPriceRepository,
         coordinator: IJBCPriceCoordinator,
         uiModel: IJBCPriceUIModel)

    var navTitle: String { get }

    // Coordinator
    func presentNewJBCPriceViewController()

    // Service
    func getPrices()

    // TableView
    func getNumberOfItemsInRow() -> Int
    func getItemCellUIModel(indexPath: IndexPath) -> JBCPriceItemCellUIModel
}

final class JBCPriceViewModel: BaseViewModel, IJBCPriceViewModel {

    // MARK: Definitions
    private let repository: IJBCPriceRepository
    private let coordinator: IJBCPriceCoordinator
    private var uiModel: IJBCPriceUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<JBCPriceViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[JBCPriceModel]?, Never>(nil)
    let cancelCustomerPriceResponse = CurrentValueSubject<Bool?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IJBCPriceRepository,
                  coordinator: IJBCPriceCoordinator,
                  uiModel: IJBCPriceUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var navTitle: String {
        return uiModel.navTitle
    }
}


// MARK: Service
internal extension JBCPriceViewModel {

    func getPrices() {
        handleResourceFirestore(
            request: self.repository.getPrices(customerId: uiModel.customerId,
                                               season: uiModel.season,
                                               stockId: uiModel.stockId,
                                               subStockId: uiModel.subStockId),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                guard let self = self,
                    let prices = self.response.value else { return }
                self.uiModel.setPrices(prices)
                self.viewStateReloadData()
            })
    }
    
    func cancelCustomerPrice(priceModel: JBCPriceModel) {
        handleResourceFirestore(
            request: self.repository.cancelCustomerPrice(season: self.uiModel.season,
                                                         priceModel: priceModel),
            response: self.cancelCustomerPriceResponse,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.delay(75) { [weak self] in
                    self?.getPrices()
                }
            })
    }
}

// MARK: States
internal extension JBCPriceViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadData() {
        viewState.value = .reloadData
    }
    
    func viewStateOutputDelegate(price: Double) {
        viewState.value = .outputDelegate(stockModel: uiModel.stockModel,
                                          subStockModel: uiModel.subStockModel,
                                          price: price)
    }
}

// MARK: Coordinate
internal extension JBCPriceViewModel {

    func presentNewJBCPriceViewController() {
        self.coordinator.presentNewJBCPriceCiewController(passData: self.uiModel.newJBCPricePassData,
                                                          outputDelegate: self)
    }

    func popToRootViewController(animated: Bool) {
        self.coordinator.popToRootViewController(animated: animated)
    }
}

// MARK: NewJBCPriceViewControllerOutputDelegate
internal extension JBCPriceViewModel {

    func newJBCPriceData(_ data: JBCPriceModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateReloadData()
    }
}

// MARK: JBCPriceItemCellOutputDelegate
internal extension JBCPriceViewModel {

    func cellTapped(uiModel: JBCPriceItemCellUIModel) {
        guard self.uiModel.isPriceSelectable else { return }
        self.viewStateOutputDelegate(price: uiModel.productPrice)
        DispatchQueue.delay(25) { [weak self] in
            self?.popToRootViewController(animated: false)
        }
    }
    
    func cancelButtonTapped(uiModel: JBCPriceItemCellUIModel) {
        self.cancelCustomerPrice(priceModel: uiModel.priceModel)
    }
}

// MARK: TableView
internal extension JBCPriceViewModel {

    func getNumberOfItemsInRow() -> Int {
        return self.uiModel.getNumberOfItemsInRow()
    }

    func getItemCellUIModel(indexPath: IndexPath) -> JBCPriceItemCellUIModel {
        return self.uiModel.getItemCellUIModel(indexPath: indexPath)
    }
}

enum JBCPriceViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadData
    case outputDelegate(stockModel: StockModel, subStockModel: SubStockModel,price: Double)
}
