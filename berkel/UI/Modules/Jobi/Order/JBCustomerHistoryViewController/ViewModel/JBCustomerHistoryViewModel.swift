//
//  JBCustomerHistoryViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.09.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IJBCustomerHistoryViewModel: AnyObject {

    var viewState: ScreenStateSubject<JBCustomerHistoryViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJBCustomerHistoryRepository,
         coordinator: IJBCustomerHistoryCoordinator,
         uiModel: IJBCustomerHistoryUIModel)
    
    var customerName: String { get }
    var season: String { get }
    
    // Service
    func getDatas()
    
    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel
}

final class JBCustomerHistoryViewModel: BaseViewModel, IJBCustomerHistoryViewModel {

    // MARK: Definitions
    private let repository: IJBCustomerHistoryRepository
    private let coordinator: IJBCustomerHistoryCoordinator
    private var uiModel: IJBCustomerHistoryUIModel

    // MARK: Private Props
    let viewState = ScreenStateSubject<JBCustomerHistoryViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseOrder = CurrentValueSubject<[OrderModel]?, Never>(nil)
    let responseCollection = CurrentValueSubject<[OrderCollectionModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IJBCustomerHistoryRepository,
                  coordinator: IJBCustomerHistoryCoordinator,
                  uiModel: IJBCustomerHistoryUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var customerName: String {
        return uiModel.customerName
    }
    
    var season: String {
        return uiModel.season
    }
}


// MARK: Service
internal extension JBCustomerHistoryViewModel {

    func getDatas() {

        handleResourceFirestore(
            request: self.repository.getOrderList(season: uiModel.season),
            response: self.responseOrder,
            errorState: self.errorState,
            callbackLoading: { isProgress in
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                let orderIdx = self.uiModel.getCutomerOrderIdx(orders: self.responseOrder.value ?? [])
                // TODO: type: "ADD" ve müşteri id'si aynı ise toplat
                orderIdx.forEach { orderId in
                    DispatchQueue.delay(25) { [weak self] in
                        self?.getSellerCollection(orderId: orderId, isLastItem: orderId == orderIdx.last)
                    }
                }
            }
        )
    }
    
    private func getSellerCollection(orderId: String, isLastItem: Bool) {
        handleResourceFirestore(
            request: self.repository.getCollection(season: uiModel.season,
                                                   customerId: uiModel.customerId,
                                                   orderId: orderId),
            response: self.responseCollection,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.groupOrdersIntoStockListModels(orderDetails: self.responseCollection.value ?? [])
            }, callbackComplete: { [weak self] in
                guard let self = self else { return }
                if isLastItem {
                    self.viewStateReloadData()
                }
            })
    }
    
}

// MARK: States
internal extension JBCustomerHistoryViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }
    
    func viewStateReloadData() {
        viewState.value = .reloadData
    }
}

// MARK: Coordinate
internal extension JBCustomerHistoryViewModel {

}

// MARK: TableView
internal extension JBCustomerHistoryViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getNumberOfItemsInRow(section: Int) -> Int {
        return self.uiModel.getNumberOfItemsInRow(section: section)
    }

    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel {
        return self.uiModel.getSectionUIModel(section: section)
    }

    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel {
        return self.uiModel.getItemCellUIModel(indexPath: indexPath)
    }
}

enum JBCustomerHistoryViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadData
}
