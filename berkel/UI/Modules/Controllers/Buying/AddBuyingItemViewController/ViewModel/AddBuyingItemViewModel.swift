//
//  AddBuyingItemViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IAddBuyingItemViewModel: AddBuyingItemDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<AddBuyingItemViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IAddBuyingItemRepository,
         coordinator: IAddBuyingItemCoordinator,
         uiModel: IAddBuyingItemUIModel)

    func updateSnapshot(currentSnapshot: AddBuyingItemSnapshot,
                        newDatas: [AddBuyingItemResponseModel]) -> AddBuyingItemSnapshot

    // Services
    func getBuyingItems()

    // Coordinator
    func presentAddSellerViewController()
}

final class AddBuyingItemViewModel: BaseViewModel, IAddBuyingItemViewModel {

    // MARK: Definitions
    private let repository: IAddBuyingItemRepository
    private let coordinator: IAddBuyingItemCoordinator
    private var uiModel: IAddBuyingItemUIModel

    // MARK: Private Props
    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    // MARK: Public Props
    var viewState = ScreenStateSubject<AddBuyingItemViewState>(nil)
    let response = CurrentValueSubject<[AddBuyingItemResponseModel]?, Never>(nil)
    var errorState = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: IAddBuyingItemRepository,
                  coordinator: IAddBuyingItemCoordinator,
                  uiModel: IAddBuyingItemUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateSnapshot(currentSnapshot: AddBuyingItemSnapshot,
                        newDatas: [AddBuyingItemResponseModel]) -> AddBuyingItemSnapshot {
        self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension AddBuyingItemViewModel {

    func getBuyingItems() {

        handleResourceFirestore(
            request: self.repository.getBuyingItemList(cursor: self.uiModel.getLastCursor(),
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
internal extension AddBuyingItemViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [AddBuyingItemResponseModel]) {
        viewState.value = .updateSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension AddBuyingItemViewModel {

    func presentAddSellerViewController() {
        self.coordinator.presentAddSellerViewController(outputDelegate: self)
    }
}

// MARK: AddSellerViewControllerOutputDelegate
extension AddBuyingItemViewModel: AddSellerViewControllerOutputDelegate {

    func newAddSellerData(_ data: AddSellerModel) {
        let _ = self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: AddBuyingItemDataSourceFactoryOutputDelegate
extension AddBuyingItemViewModel {

    func phoneNumberTapped(phoneNumber: String) {
        PhoneCallHelper.shared.makeACall(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: IAddBuyingItemTableViewCellUIModel) {
        print("**** \(uiModel)")
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getBuyingItems()
        }
    }
}

enum AddBuyingItemViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: AddBuyingItemSnapshot)
    case updateSnapshot(data: [AddBuyingItemResponseModel])
}
