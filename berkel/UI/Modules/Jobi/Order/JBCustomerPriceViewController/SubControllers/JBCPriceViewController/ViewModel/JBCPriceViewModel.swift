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
}

// MARK: Coordinate
internal extension JBCPriceViewModel {

    func presentNewJBCPriceViewController() {
        self.coordinator.presentNewJBCPriceCiewController(passData: self.uiModel.newJBCPricePassData,
                                                          outputDelegate: self)
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
}
