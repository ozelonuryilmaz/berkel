//
//  StockViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Foundation
import Combine

protocol IStockViewModel: MyStockListViewControllerOutputDelegate, StockHeaderCellOutputDelegate {

    var viewState: ScreenStateSubject<StockViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IStockRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IStockCoordinator,
         uiModel: IStockUIModel)
    
    // Service
    func getStock()

    // Coordinator
    func pushMyStockListViewController()

    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> StockHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> StockItemCellUIModel
}

final class StockViewModel: BaseViewModel, IStockViewModel {

    // MARK: Definitions
    private let repository: IStockRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IStockCoordinator
    private var uiModel: IStockUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<StockViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseStockList = CurrentValueSubject<[StockModel]?, Never>(nil)
    let responseSubStockList = CurrentValueSubject<[SubStockModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IStockRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IStockCoordinator,
                  uiModel: IStockUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var season: String {
        return uiModel.season
    }
    
    private func reloadData() {
        self.uiModel.sortedStocks()
        self.viewStateReloadData()
    }
}


// MARK: Service
internal extension StockViewModel {

    func getStock() {
        viewStateShowNativeProgress(isProgress: true)
        uiModel.resetValues()

        handleResourceFirestore(
            request: self.jobiStockRepository.getStock(season: self.uiModel.season),
            response: self.responseStockList,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self, let stockList = self.responseStockList.value else { return }
                self.uiModel.setStockIdx(idx: stockList.compactMap({ $0.id }))
                for stock in stockList {
                    self.getSubStock(stock: stock)
                }
            },
            callbackComplete: { [weak self] in
                guard let self = self, let stockList = self.responseStockList.value else { return }
                if stockList.isEmpty {
                    self.viewStateShowNativeProgress(isProgress: false)
                    self.reloadData()
                }
            })
    }

    private func getSubStock(stock: StockModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.handleResourceFirestore(
                request: self.jobiStockRepository.getSubStock(season: self.uiModel.season, stockId: stock.id ?? ""),
                response: self.responseSubStockList,
                errorState: self.errorState,
                callbackLoading: { [weak self] isProgress in
                    guard let self = self else { return }
                    self.viewStateShowNativeProgress(isProgress: isProgress)
                },
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
internal extension StockViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateReloadData() {
        viewState.value = .reloadData
    }
}

// MARK: Coordinate
internal extension StockViewModel {

    func pushMyStockListViewController() {
        self.coordinator.pushMyStockListViewController(passData: MyStockListPassData(),
                                                       outputDelegate: self)
    }
}

// MARK: MyStockListViewControllerOutputDelegate
internal extension StockViewModel {

    func stockData(_ data: StockListModel) {
        
    }
}

// MARK: StockHeaderCellOutputDelegate
internal extension StockViewModel {
    
    func updateStockCounts(stockModel: StockModel) {
        
    }
}

// MARK: TableView
internal extension StockViewModel {

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

enum StockViewState {
    case showNativeProgress(isProgress: Bool)
    case reloadData
}
