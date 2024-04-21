//
//  JBCustomerPriceViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IJBCustomerPriceViewModel: StockItemCellOutputDelegate, 
                                        JBCPriceViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<JBCustomerPriceViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJBCustomerPriceRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IJBCustomerPriceCoordinator,
         uiModel: IJBCustomerPriceUIModel)
    
    var customerName: String { get }
    
    // Coordinate
    func dismiss()
    
    // Service
    func getStock()
    
    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel
}

final class JBCustomerPriceViewModel: BaseViewModel, IJBCustomerPriceViewModel {

    // MARK: Definitions
    private let repository: IJBCustomerPriceRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IJBCustomerPriceCoordinator
    private var uiModel: IJBCustomerPriceUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<JBCustomerPriceViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseStockList = CurrentValueSubject<[StockModel]?, Never>(nil)
    let responseSubStockList = CurrentValueSubject<[SubStockModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IJBCustomerPriceRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IJBCustomerPriceCoordinator,
                  uiModel: IJBCustomerPriceUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }
    
    var customerName: String {
        return uiModel.customerName
    }
    
    private func reloadData() {
        self.uiModel.sortedStocks()
        self.viewStateReloadData()
    }
}


// MARK: Service
internal extension JBCustomerPriceViewModel {

    func getStock() {
        viewStateShowNativeProgress(isProgress: true)
        uiModel.resetValues()
        reloadData()

        handleResourceFirestore(
            request: self.jobiStockRepository.getStocks(season: self.uiModel.season),
            response: self.responseStockList,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self, let stockList = self.responseStockList.value else { return }
                self.uiModel.setStockIdx(idx: stockList.compactMap({ $0.id }))
                for stock in stockList {
                    self.getSubStocks(stock: stock)
                }
            },
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                let stockList = self.responseStockList.value ?? []
                if stockList.isEmpty  {
                    self.viewStateShowNativeProgress(isProgress: false)
                    self.reloadData()
                }
            })
    }
    
    private func getSubStocks(stock: StockModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.handleResourceFirestore(
                request: self.jobiStockRepository.getSubStocks(season: self.uiModel.season, stockId: stock.id ?? ""),
                response: self.responseSubStockList,
                errorState: self.errorState,
                callbackSuccess: { [weak self] in
                    guard let self = self,
                        let subStockList = self.responseSubStockList.value else { return }
                    self.uiModel.setStock(stock: stock, subStock: subStockList)
                },
                callbackComplete: { [weak self] in
                    guard let self = self else { return }
                    if self.uiModel.isLastRequest {
                        self.viewStateShowNativeProgress(isProgress: false)
                        self.reloadData()
                    }
                })
        }
    }
}

// MARK: States
internal extension JBCustomerPriceViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadData() {
        viewState.value = .reloadData
    }

    func viewStateReloadDataWith(indexPath: IndexPath) {
        viewState.value = .reloadDataWith(indexPath: indexPath)
    }

    func viewStateShowToastMessage(message: String) {
        viewState.value = .showToastMessage(message: message)
    }
}

// MARK: Coordinate
internal extension JBCustomerPriceViewModel {
    
    func pushJBCPriceViewController() {
        self.coordinator.pushJBCPriceViewController(passData: JBCPricePassData(),
                                                    outputDelegate: self)
    }

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: StockItemCellOutputDelegate
internal extension JBCustomerPriceViewModel {

    func subStockTapped(subStock: SubStockModel) {
        self.pushJBCPriceViewController()
    }
}

// MARK: JBCPriceViewControllerOutputDelegate
internal extension JBCustomerPriceViewModel {
    
}

// MARK: TableView
internal extension JBCustomerPriceViewModel {

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

enum JBCustomerPriceViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadData
    case reloadDataWith(indexPath: IndexPath)
    case showToastMessage(message: String)
}
