//
//  BuyingViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Combine

protocol IBuyingViewModel: AddBuyingItemViewControllerOutputDelegate, BuyingDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<BuyingViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IBuyingRepository,
         coordinator: IBuyingCoordinator,
         uiModel: IBuyingUIModel)

    var season: String { get }

    // Service
    func getBuying()

    // Coordinate
    func pushAddBuyinItemViewController()

    // DataSource
    func updateSnapshot(currentSnapshot: BuyingSnapshot,
                        newDatas: [NewBuyingModel]) -> BuyingSnapshot
}

final class BuyingViewModel: BaseViewModel, IBuyingViewModel {

    // MARK: Definitions
    private let repository: IBuyingRepository
    private let coordinator: IBuyingCoordinator
    private var uiModel: IBuyingUIModel

    var viewState = ScreenStateSubject<BuyingViewState>(nil)
    let response = CurrentValueSubject<[NewBuyingModel]?, Never>(nil)
    var errorState = ErrorStateSubject(nil)

    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    // MARK: Initiliazer
    required init(repository: IBuyingRepository,
                  coordinator: IBuyingCoordinator,
                  uiModel: IBuyingUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var season: String {
        return uiModel.season
    }

    func updateSnapshot(currentSnapshot: BuyingSnapshot,
                        newDatas: [NewBuyingModel]) -> BuyingSnapshot {
        return self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension BuyingViewModel {

    func getBuying() {

        handleResourceFirestore(
            request: self.repository.getBuyingList(season: self.uiModel.season,
                                                   cursor: self.uiModel.getLastCursor(),
                                                   limit: self.uiModel.limit),
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
internal extension BuyingViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [NewBuyingModel]) {
        viewState.value = .updateSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension BuyingViewModel {

    func pushAddBuyinItemViewController() {
        self.coordinator.pushAddBuyinItemViewController(outputDelegate: self)
    }

    func pushBuyingDetailViewController(passData: BuyingDetailPassData) {
        self.coordinator.pushBuyingDetailViewController(passData: passData,
                                                        successDismissCallBack: { isActive in
            self.uiModel.updateIsActive(buyingId: passData.buyingId, isActive: isActive)
            self.viewStateBuildSnapshot()
        })
    }

    func presentBuyingCollectionViewController(passData: BuyingCollectionPassData,
                                               successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?) {
        self.coordinator.presentBuyingCollectionViewController(passData: passData,
                                                               successDismissCallBack: successDismissCallBack)
    }

    func presentBuyingPaymentViewController(passData: BuyingPaymentPassData) {
        self.coordinator.presentBuyingPaymentViewController(passData: passData)
    }
}

// MARK: AddBuyingItemViewControllerOutputDelegate
extension BuyingViewModel {

    func newAddBuyingData(_ data: NewBuyingModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }

}

// MARK: BuyingDataSourceFactoryOutputDelegate
extension BuyingViewModel {

    func cellTapped(uiModel: IBuyingTableViewCellUIModel) {
        let data = BuyingDetailPassData(buyingId: uiModel.id,
                                        sellerId: uiModel.sellerId,
                                        sellerName: uiModel.sellerName,
                                        productName: uiModel.productName,
                                        isActive: uiModel.isActive)
        self.pushBuyingDetailViewController(passData: data)
    }

    func addCollectionTapped(uiModel: IBuyingTableViewCellUIModel) {
        let passData = BuyingCollectionPassData(buyingId: uiModel.id,
                                                kgPrice: uiModel.kg,
                                                sellerId: uiModel.sellerId,
                                                sellerName: uiModel.sellerName,
                                                productName: uiModel.productName,
                                                model: nil)
        self.presentBuyingCollectionViewController(passData: passData,
                                                   successDismissCallBack: { _ in })
    }

    func addPaymentTapped(uiModel: IBuyingTableViewCellUIModel) {
        let passData = BuyingPaymentPassData(buyingId: uiModel.id,
                                             sellerId: uiModel.sellerId,
                                             sellerName: uiModel.sellerName,
                                             productName: uiModel.productName)

        self.presentBuyingPaymentViewController(passData: passData)
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getBuying()
        }
    }
}

enum BuyingViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: BuyingSnapshot)
    case updateSnapshot(data: [NewBuyingModel])
}
