//
//  StockDetailInformationViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Combine

protocol IStockDetailInformationViewModel: UpdateStockViewControllerOutputDelegate,
                                           StockDetailInfoDataSourceFactoryOutputDelegate{

    var viewState: ScreenStateSubject<StockDetailInformationViewState> { get }
    var errorState: ErrorStateSubject { get }

    var navigationTitle: String { get }
    var navigationSubTitle: String { get }

    init(repository: IStockDetailInformationRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IStockDetailInformationCoordinator,
         uiModel: IStockDetailInformationUIModel)

    // Coordinate
    func presentUpdateStockViewController(type: UpdateStockType)
    
    // Service
    func getStockList()

    func updateSnapshot(currentSnapshot: StockDetailInfoSnapshot,
                        newDatas: [UpdateStockModel]) -> StockDetailInfoSnapshot
}

final class StockDetailInformationViewModel: BaseViewModel, IStockDetailInformationViewModel {

    // MARK: Definitions
    private let repository: IStockDetailInformationRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IStockDetailInformationCoordinator
    private var uiModel: IStockDetailInformationUIModel

    // MARK: Public Props
    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false
    
    var viewState = ScreenStateSubject<StockDetailInformationViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[UpdateStockModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IStockDetailInformationRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IStockDetailInformationCoordinator,
                  uiModel: IStockDetailInformationUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var navigationTitle: String {
        return uiModel.navigationTitle
    }

    var navigationSubTitle: String {
        return uiModel.navigationSubTitle
    }
    
    func updateSnapshot(currentSnapshot: StockDetailInfoSnapshot,
                        newDatas: [UpdateStockModel]) -> StockDetailInfoSnapshot {
        self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension StockDetailInformationViewModel {

    func getStockList() {
        handleResourceFirestore(
            request: jobiStockRepository.getStockInfo(cursor: uiModel.getLastCursor(),
                                                      limit: uiModel.limit,
                                                      season: uiModel.season,
                                                      stockId: uiModel.stockId,
                                                      subStockId: uiModel.subStockId),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { isProgress in
                self.viewStateShowNativeProgress(isProgress: isProgress)
                self.isAvailablePagination = !isProgress
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setResponse(self.response.value ?? [])
                if !self.uiModel.isHaveBuildData {
                    self.viewStateBuildSnapshot()
                } else {
                    self.viewStateUpdateSnapshot(data: self.response.value ?? [])
                }

                if true == self.response.value?.isEmpty {
                    self.isLastPage = true
                }
            }
        )
    }
}

// MARK: States
internal extension StockDetailInformationViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }
    
    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [UpdateStockModel]) {
        viewState.value = .updateSnapshot(data: data)
    }

}

// MARK: Coordinate
internal extension StockDetailInformationViewModel {

    func presentUpdateStockViewController(type: UpdateStockType) {
        self.coordinator.presentUpdateStockViewController(passData: uiModel.getUpdateStockPassData(type: type),
                                                          outputDelegate: self)
    }
}

// MARK: UpdateStockViewControllerOutputDelegate
internal extension StockDetailInformationViewModel {
    
    func updateStockData(_ data: UpdateStockModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: StockDetailInfoDataSourceFactoryOutputDelegate
extension StockDetailInformationViewModel {

    func cellTapped(uiModel: IStockDetailInfoTableViewCellUIModel) {
        
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getStockList()
        }
    }
}

enum StockDetailInformationViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: StockDetailInfoSnapshot)
    case updateSnapshot(data: [UpdateStockModel])
}
