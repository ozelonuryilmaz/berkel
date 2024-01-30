//
//  SellerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Combine

protocol ISellerViewModel: NewSellerViewControllerOutputDelegate,
    SellerDataSourceFactoryOutputDelegate,
    SellerDetailViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<SellerViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: ISellerRepository,
         coordinator: ISellerCoordinator,
         uiModel: ISellerUIModel)

    // Coordinate
    func pushCustomerListViewController()

    // Service
    func getSeller()

    // DataSource
    func updateSnapshot(currentSnapshot: SellerSnapshot,
                        newDatas: [SellerModel]) -> SellerSnapshot
}

final class SellerViewModel: BaseViewModel, ISellerViewModel {

    // MARK: Definitions
    private let repository: ISellerRepository
    private let coordinator: ISellerCoordinator
    private var uiModel: ISellerUIModel

    var viewState = ScreenStateSubject<SellerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[SellerModel]?, Never>(nil)

    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    var season: String {
        return uiModel.season
    }

    // MARK: Initiliazer
    required init(repository: ISellerRepository,
                  coordinator: ISellerCoordinator,
                  uiModel: ISellerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateSnapshot(currentSnapshot: SellerSnapshot,
                        newDatas: [SellerModel]) -> SellerSnapshot {
        return self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension SellerViewModel {

    func getSeller() {

        handleResourceFirestore(
            request: self.repository.getSellerList(season: self.uiModel.season,
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
internal extension SellerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [SellerModel]) {
        viewState.value = .updateSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension SellerViewModel {

    func pushCustomerListViewController() {

        self.coordinator.pushCustomerListViewController(passData: CustomerListPassData(),
                                                        outputDelegate: self)
    }

    func pushSellerDetailViewController(passData: SellerDetailPassData) {
        self.coordinator.pushSellerDetailViewController(passData: passData,
                                                        outputDelegate: self)
    }

    func presentSellerCollectionViewController(passData: SellerCollectionPassData) {
        self.coordinator.presentSellerCollectionViewController(passData: passData)
    }

    func presentSellerPaymentViewController(passData: SellerPaymentPassData) {
        self.coordinator.presentSellerPaymentViewController(passData: passData)
    }
}

// MARK: NewSellerViewControllerOutputDelegate
internal extension SellerViewModel {

    func newSellerData(_ data: SellerModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: SellerDataSourceFactoryOutputDelegate
extension SellerViewModel {

    func cellTapped(uiModel: ISellerTableViewCellUIModel) {
        let data = SellerDetailPassData(sellerId: uiModel.sellerId,
                                        customerName: uiModel.customerName,
                                        customerId: uiModel.customerId,
                                        isActive: uiModel.isActive,
                                        productName: uiModel.productName,
                                        productId: uiModel.productId)
        self.pushSellerDetailViewController(passData: data)
    }

    func addCollectionTapped(uiModel: ISellerTableViewCellUIModel) {
        let passData = SellerCollectionPassData(sellerModel: uiModel.sellerModel)
        self.presentSellerCollectionViewController(passData: passData)
    }

    func addPaymentTapped(uiModel: ISellerTableViewCellUIModel) {
        let passData = SellerPaymentPassData(sellerId: uiModel.sellerId,
                                             customerName: uiModel.customerName,
                                             customerId: uiModel.customerId,
                                             productName: uiModel.productName)
        self.presentSellerPaymentViewController(passData: passData)
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getSeller()
        }
    }
}

// MARK: SellerDetailViewControllerOutputDelegate
internal extension SellerViewModel {

    func closeButtonTapped(sellerId: String, isActive: Bool) {
        self.uiModel.updateIsActive(sellerId: sellerId, isActive: isActive)
        self.viewStateBuildSnapshot()
    }
}

enum SellerViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: SellerSnapshot)
    case updateSnapshot(data: [SellerModel])
}
