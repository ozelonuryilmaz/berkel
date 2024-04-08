//
//  StockViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Foundation
import Combine

protocol IStockViewModel: MyStockListViewControllerOutputDelegate,
    StockHeaderCellOutputDelegate,
    StockItemCellOutputDelegate {

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
    var tempErrorState = ErrorStateSubject(nil)
    let responseStockList = CurrentValueSubject<[StockModel]?, Never>(nil)
    let responseSubStockList = CurrentValueSubject<[SubStockModel]?, Never>(nil)
    let responseSubStock = CurrentValueSubject<SubStockModel?, Never>(nil)
    let responseSubStockInfoList = CurrentValueSubject<[UpdateStockModel]?, Never>(nil)
    let responseUpdateStockCount = CurrentValueSubject<Bool?, Never>(nil)
    let responseStockDate = CurrentValueSubject<Bool?, Never>(nil)

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
                guard let self = self, let stockList = self.responseStockList.value else { return }
                if stockList.isEmpty {
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

// MARK: Update Button Tapped Service
private extension StockViewModel {

    // Sayfa açılışında count çekiliyor.
    // Güncelleme sonrası da güncel count çekiliyor
    // ilk count ile son count aynı ise stock girişi yapılmadığı anlaşılıyor
    // ve stock güncelleniyor.
    func getSubStockInfos(stockModel: StockModel) {
        self.viewStateShowNativeProgress(isProgress: true)
        let subStocks = self.uiModel.getSubStockIdx(stockId: stockModel.id)
        for subStockModel in subStocks {
            DispatchQueue.delay(5) { [weak self] in
                guard let self = self else { return }
                self.getSubStockInfos(stock: stockModel, subStock: subStockModel)
            }
        }
    }

    func getSubStockInfos(stock: StockModel, subStock: SubStockModel) {
        self.handleResourceFirestore(
            request: self.jobiStockRepository.getSubStockInfos(cursor: nil,
                                                               limit: nil,
                                                               season: uiModel.season,
                                                               stockId: stock.id ?? "",
                                                               subStockId: subStock.id ?? ""),
            response: self.responseSubStockInfoList,
            errorState: self.errorState,
            callbackComplete: { [weak self] in
                guard let self = self, let infos = self.responseSubStockInfoList.value else {
                    self?.viewStateShowNativeProgress(isProgress: false)
                    return
                }
                let subStockInfoCount = infos.map({ $0.count }).reduce(0, +)
                DispatchQueue.delay(2) { [weak self] in
                    guard let self = self else { return }
                    self.getSubStock(subStockInfoCount: subStockInfoCount, stock: stock, subStock: subStock)
                }
            })
    }

    func getSubStock(subStockInfoCount: Int, stock: StockModel, subStock: SubStockModel) {
        self.handleResourceFirestore(
            request: self.jobiStockRepository.getSubStock(season: uiModel.season,
                                                          stockId: stock.id ?? "",
                                                          subStockId: subStock.id ?? ""),
            response: self.responseSubStock,
            errorState: self.errorState,
            callbackComplete: { [weak self] in
                guard let self = self, let _subStock = self.responseSubStock.value else {
                    self?.viewStateShowNativeProgress(isProgress: false)
                    return
                }
                // Güncelleme başlatıldığında count ile güncelleme bittiğindeki çekilen count eşitse toplam count ile güncelleyebilirsin
                if _subStock.counter == subStock.counter {
                    self.updateSubStockCount(subStockInfoCount: subStockInfoCount, stock: stock, subStock: subStock)
                } else {
                    self.viewStateShowNativeProgress(isProgress: false)
                    self.viewStateShowToastMessage(message: "Stok giriş/çıkış yapıldığı için güncelleme yapılamadı")
                }
            })
    }

    func updateSubStockCount(subStockInfoCount: Int, stock: StockModel, subStock: SubStockModel) {
        self.handleResourceFirestore(
            request: self.jobiStockRepository.updateSubStockCount(count: subStockInfoCount,
                                                                  season: uiModel.season,
                                                                  stockId: stock.id ?? "",
                                                                  subStockId: subStock.id ?? ""),
            response: self.responseUpdateStockCount,
            errorState: self.errorState,
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                if true == self.responseUpdateStockCount.value {
                    DispatchQueue.delay(5) { [weak self] in
                        guard let self = self else { return }
                        guard let indexPath = self.uiModel.updateSubStockCount(subStockInfoCount,
                                                                               stockId: stock.id,
                                                                               subStockId: subStock.id) else { return }

                        self.updateStockDate(stock: stock, completion: { [weak self] in
                            guard let self = self else { return }
                            self.viewStateReloadDataWith(indexPath: indexPath)

                            // Son subStock'a gelinmişse progress'i kapat
                            if self.uiModel.getSubStockIdx(stockId: stock.id).last?.id == subStock.id {
                                self.viewStateShowNativeProgress(isProgress: false)
                            }
                        })
                    }
                } else {
                    self.viewStateShowNativeProgress(isProgress: false)
                    self.viewStateShowToastMessage(message: "Stok güncelleme işlemini yeniden deneyiniz")
                }
            })
    }

    func updateStockDate(stock: StockModel, completion: @escaping () -> Void) {
        let date: String  = Date().dateFormatterApiResponseType()

        self.handleResourceFirestore(
            request: self.jobiStockRepository.updateStockDate(season: season,
                                                              stockId: stock.id ?? "",
                                                              date: date),
            response: self.responseStockDate,
            errorState: self.tempErrorState,
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                self.uiModel.updateStockDate(date, stockId: stock.id)
                completion()
            })
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

    func viewStateReloadDataWith(indexPath: IndexPath) {
        viewState.value = .reloadDataWith(indexPath: indexPath)
    }

    func viewStateShowToastMessage(message: String) {
        viewState.value = .showToastMessage(message: message)
    }

}

// MARK: Coordinate
internal extension StockViewModel {

    func pushMyStockListViewController() {
        self.coordinator.pushMyStockListViewController(passData: MyStockListPassData(),
                                                       outputDelegate: self)
    }

    func pushStockDetailInfoViewController(subStockModel: SubStockModel) {
        guard let stockModel = self.uiModel.getStockModel(subStockId: subStockModel.id) else { return }
        let passData = StockDetailInformationPassData(stockModel: stockModel, subStockModel: subStockModel)
        self.coordinator.pushStockDetailInfoViewController(passData: passData)
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
        self.getSubStockInfos(stockModel: stockModel)
    }
}

// MARK: StockItemCellOutputDelegate
internal extension StockViewModel {

    func subStockTapped(subStock: SubStockModel) {
        self.pushStockDetailInfoViewController(subStockModel: subStock)
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
    case reloadDataWith(indexPath: IndexPath)
    case showToastMessage(message: String)
}
