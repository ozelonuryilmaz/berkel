//
//  OtherSellerListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol IOtherSellerListViewModel: NewOtherItemViewControllerOutputDelegate,
    NewOtherSellerViewControllerOutputDelegate,
    OtherSellerListDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<OtherSellerListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOtherSellerListRepository,
         coordinator: IOtherSellerListCoordinator,
         uiModel: IOtherSellerListUIModel)

    // Coordinator
    func presentNewOtherSellerViewController(passData: NewOtherSellerPassData)

    // Service
    func getOtherSellerList()

    func updateSnapshot(currentSnapshot: OtherSellerListSnapshot,
                        newDatas: [OtherSellerModel]) -> OtherSellerListSnapshot
}

final class OtherSellerListViewModel: BaseViewModel, IOtherSellerListViewModel {

    // MARK: Definitions
    private let repository: IOtherSellerListRepository
    private let coordinator: IOtherSellerListCoordinator
    private var uiModel: IOtherSellerListUIModel

    // MARK: Public Props
    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    var viewState = ScreenStateSubject<OtherSellerListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[OtherSellerModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOtherSellerListRepository,
                  coordinator: IOtherSellerListCoordinator,
                  uiModel: IOtherSellerListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateSnapshot(currentSnapshot: OtherSellerListSnapshot,
                        newDatas: [OtherSellerModel]) -> OtherSellerListSnapshot {
        self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension OtherSellerListViewModel {

    func getOtherSellerList() {
        handleResourceFirestore(
            request: self.repository.getOtherSellerList(cursor: self.uiModel.getLastCursor(),
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
internal extension OtherSellerListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [OtherSellerModel]) {
        viewState.value = .updateSnapshot(data: data)
    }

    func viewStateOutputDelegate(otherModel: OtherModel) {
        self.viewState.value = .outputDelegate(otherModel: otherModel)
    }

    func popToRootViewController(animated: Bool) {
        self.coordinator.popToRootViewController(animated: animated)
    }

    func pushArchiveListViewController(otherSellerId: String) {
        // MARK: otherId kullanılmıyor
        let data = ArchiveListPassData(imagePageType: .other(otherSellerId: otherSellerId,
                                                             otherId: "",
                                                             otherSellerProductName: ""))
        self.coordinator.pushArchiveListViewController(passData: data)
    }
}

// MARK: Coordinate
internal extension OtherSellerListViewModel {

    func presentNewOtherSellerViewController(passData: NewOtherSellerPassData) {
        self.coordinator.presentNewOtherSellerViewController(passData: passData,
                                                             outputDelegate: self)
    }

    func presentNewOtherItemViewController(passData: NewOtherItemPassData) {
        self.coordinator.presentNewOtherItemViewController(passData: passData,
                                                           outputDelegate: self)
    }
}

// MARK: NewOtherSellerViewControllerOutputDelegate
internal extension OtherSellerListViewModel {

    func otherSellerData(_ data: OtherSellerModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: NewOtherItemViewControllerOutputDelegate
internal extension OtherSellerListViewModel {

    func newOtherItemData(_ data: OtherModel) {
        self.viewStateOutputDelegate(otherModel: data)
        self.popToRootViewController(animated: true)
    }
}

// MARK: OtherSellerListDataSourceFactoryOutputDelegate
extension OtherSellerListViewModel {

    func phoneNumberTapped(phoneNumber: String) {
        PhoneCallHelper.shared.makeACall(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: IOtherSellerListTableViewCellUIModel) {
        if !self.uiModel.isCancellableCellTabbed {
            let passData = NewOtherItemPassData()
            self.presentNewOtherItemViewController(passData: passData)
        }
    }

    func archiveTapped(otherSellerId: String) {
        self.pushArchiveListViewController(otherSellerId: otherSellerId)
    }

    func updateTapped(uiModel: IOtherSellerListTableViewCellUIModel) {
        self.presentNewOtherSellerViewController(passData: NewOtherSellerPassData(otherSellerInformation: uiModel))
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getOtherSellerList()
        }
    }
}

enum OtherSellerListViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: OtherSellerListSnapshot)
    case updateSnapshot(data: [OtherSellerModel])
    case outputDelegate(otherModel: OtherModel)
}
