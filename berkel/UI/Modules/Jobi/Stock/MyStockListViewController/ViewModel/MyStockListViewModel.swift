//
//  MyStockListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Foundation
import Combine

protocol IMyStockListViewModel: MyStockListHeaderCellOutputDelegate {

    var viewState: ScreenStateSubject<MyStockListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IMyStockListRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IMyStockListCoordinator,
         uiModel: IMyStockListUIModel)

    // Service
    func getStock()
    func saveStock(name: String)
    func saveSubStock(name: String, stockId: String)

    // TableView
    func getNumberOfItemsInSection() -> Int
    func getNumberOfItemsInRow(section: Int) -> Int
    func getSectionUIModel(section: Int) -> MyStockListHeaderCellUIModel
    func getItemCellUIModel(indexPath: IndexPath) -> MyStockListItemCellUIModel
}

final class MyStockListViewModel: BaseViewModel, IMyStockListViewModel {

    // MARK: Definitions
    private let repository: IMyStockListRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IMyStockListCoordinator
    private var uiModel: IMyStockListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<MyStockListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseStock = CurrentValueSubject<StockModel?, Never>(nil)
    let responseStockList = CurrentValueSubject<[StockModel]?, Never>(nil)
    let responseSubStock = CurrentValueSubject<SubStockModel?, Never>(nil)
    let responseSubStockList = CurrentValueSubject<[SubStockModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IMyStockListRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IMyStockListCoordinator,
                  uiModel: IMyStockListUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    private func reloadData() {
        self.uiModel.sortedStocks()
        self.viewStateReloadData()
    }
}


// MARK: Service
internal extension MyStockListViewModel {

    func saveStock(name: String) {
        handleResourceFirestore(
            request: self.jobiStockRepository.saveStock(season: self.uiModel.season,
                                                        data: self.uiModel.getStockModel(name: name)),
            response: self.responseStock,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let stockModel = self.responseStock.value else { return }
                self.uiModel.setStock(stock: stockModel, subStock: [])
                self.reloadData()
            })
    }

    func saveSubStock(name: String, stockId: String) {
        handleResourceFirestore(
            request: self.jobiStockRepository.saveSubStock(season: self.uiModel.season,
                                                           stockId: stockId,
                                                           data: self.uiModel.getSubStockModel(name: name)),
            response: self.responseSubStock,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.resetValues()
                self.getStock()
            })
    }

    func getStock() {
        viewStateShowNativeProgress(isProgress: true)

        handleResourceFirestore(
            request: self.jobiStockRepository.getStock(season: self.uiModel.season),
            response: self.responseStockList,
            errorState: self.errorState,
            callbackSuccess: { [weak self] in
                guard let self = self, let stockList = self.responseStockList.value else { return }
                self.uiModel.setStockIdx(idx: stockList.compactMap({ $0.id }))
                self.reloadData()
                for stock in stockList {
                    self.getSubStock(stock: stock)
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

                    if self.uiModel.isLastRequest {
                        self.reloadData()
                        self.viewStateShowNativeProgress(isProgress: false)
                    }
                })
        }
    }
}

// MARK: States
internal extension MyStockListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateNewSubStockCategoryWithTextField(uiModel: MyStockListHeaderCellUIModel) {
        viewState.value = .newSubStockCategoryWithTextField(uiModel: uiModel)
    }

    func viewStateReloadData() {
        viewState.value = .reloadData
    }
}

// MARK: Coordinate
internal extension MyStockListViewModel {

}

// MARK: MyStockListHeaderCellOutputDelegate
internal extension MyStockListViewModel {

    func appendSubStockButtonTap(uiModel: MyStockListHeaderCellUIModel) {
        self.viewStateNewSubStockCategoryWithTextField(uiModel: uiModel)
    }
}

// MARK: TableView
internal extension MyStockListViewModel {

    func getNumberOfItemsInSection() -> Int {
        return self.uiModel.getNumberOfItemsInSection()
    }

    func getNumberOfItemsInRow(section: Int) -> Int {
        return self.uiModel.getNumberOfItemsInRow(section: section)
    }

    func getSectionUIModel(section: Int) -> MyStockListHeaderCellUIModel {
        return self.uiModel.getSectionUIModel(section: section)
    }

    func getItemCellUIModel(indexPath: IndexPath) -> MyStockListItemCellUIModel {
        return self.uiModel.getItemCellUIModel(indexPath: indexPath)
    }
}

enum MyStockListViewState {
    case showNativeProgress(isProgress: Bool)
    case newSubStockCategoryWithTextField(uiModel: MyStockListHeaderCellUIModel)
    case reloadData
}
