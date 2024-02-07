//
//  OtherViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol IOtherViewModel: NewOtherItemViewControllerOutputDelegate,
    OtherDataSourceFactoryOutputDelegate,
    OtherDetailViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<OtherViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IOtherRepository,
         coordinator: IOtherCoordinator,
         uiModel: IOtherUIModel)

    // Coordinator
    func pushOtherItemListViewController()

    // Service
    func getOther()

    // DataSource
    func updateSnapshot(currentSnapshot: OtherSnapshot,
                        newDatas: [OtherModel]) -> OtherSnapshot
}

final class OtherViewModel: BaseViewModel, IOtherViewModel {

    // MARK: Definitions
    private let repository: IOtherRepository
    private let coordinator: IOtherCoordinator
    private var uiModel: IOtherUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[OtherModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOtherRepository,
                  coordinator: IOtherCoordinator,
                  uiModel: IOtherUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var season: String {
        return uiModel.season
    }

    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    func updateSnapshot(currentSnapshot: OtherSnapshot,
                        newDatas: [OtherModel]) -> OtherSnapshot {
        return self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension OtherViewModel {

    func getOther() {

        handleResourceFirestore(
            request: self.repository.getOtherList(season: self.uiModel.season,
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
internal extension OtherViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [OtherModel]) {
        viewState.value = .updateSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension OtherViewModel {

    func pushOtherItemListViewController() {
        self.coordinator.pushOtherSellerListViewController(passData: OtherSellerListPassData(),
                                                           outputDelegate: self)
    }

    func pushOtherDetailViewController(passData: OtherDetailPassData) {
        self.coordinator.pushOtherDetailViewController(passData: passData,
                                                       outputDelegate: self)
    }

    func presentOtherCollectionViewController(passData: OtherCollectionPassData) {
        self.coordinator.presentOtherCollectionViewController(passData: passData)
    }

    func presentOtherPaymentViewController(passData: OtherPaymentPassData) {
        self.coordinator.presentOtherPaymentViewController(passData: passData)
    }
}

// MARK: NewOtherItemViewControllerOutputDelegate
internal extension OtherViewModel {

    func newOtherItemData(_ data: OtherModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: OtherDataSourceFactoryOutputDelegate
internal extension OtherViewModel {

    func cellTapped(uiModel: IOtherTableViewCellUIModel) {
        let data = OtherDetailPassData(otherId: uiModel.otherId,
                                       otherSellerName: uiModel.otherSellerName,
                                       otherSellerId: uiModel.otherSellerId,
                                       isActive: uiModel.isActive,
                                       categoryName: uiModel.categoryName,
                                       categoryId: uiModel.categoryId)
        self.pushOtherDetailViewController(passData: data)
    }

    func addCollectionTapped(uiModel: IOtherTableViewCellUIModel) {
        let passData = OtherCollectionPassData(otherModel: uiModel.otherModel)
        self.presentOtherCollectionViewController(passData: passData)
    }

    func addPaymentTapped(uiModel: IOtherTableViewCellUIModel) {
        let passData = OtherPaymentPassData(otherId: uiModel.otherId,
                                            otherSellerName: uiModel.otherSellerName,
                                            otherSellerId: uiModel.otherSellerId,
                                            categoryName: uiModel.categoryName)
        self.presentOtherPaymentViewController(passData: passData)
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getOther()
        }
    }
}

// MARK: OtherDetailViewControllerOutputDelegate
internal extension OtherViewModel {

    func closeButtonTapped(otherId: String, isActive: Bool) {
        self.uiModel.updateIsActive(otherId: otherId, isActive: isActive)
        self.viewStateBuildSnapshot()
    }
}

enum OtherViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: OtherSnapshot)
    case updateSnapshot(data: [OtherModel])
}
