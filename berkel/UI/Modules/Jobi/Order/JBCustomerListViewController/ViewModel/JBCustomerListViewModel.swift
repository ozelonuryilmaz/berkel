//
//  JBCustomerListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IJBCustomerListViewModel: NewJBCustomerViewControllerOutputDelegate,
    JBCustomerListDataSourceFactoryOutputDelegate,
    JBCustomerPriceViewControllerOutputDelegate,
    NewOrderViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<JBCustomerListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IJBCustomerListRepository,
         coordinator: IJBCustomerListCoordinator,
         uiModel: IJBCustomerListUIModel)

    // Coordinator
    func presentNewJBCustomerViewController(passData: NewJBCustomerPassData)

    // Service
    func getCustomerList()

    func updateSnapshot(currentSnapshot: JBCustomerListSnapshot,
                        newDatas: [JBCustomerModel]) -> JBCustomerListSnapshot
}

final class JBCustomerListViewModel: BaseViewModel, IJBCustomerListViewModel {


    // MARK: Definitions
    private let repository: IJBCustomerListRepository
    private let coordinator: IJBCustomerListCoordinator
    private var uiModel: IJBCustomerListUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<JBCustomerListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[JBCustomerModel]?, Never>(nil)

    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    // MARK: Initiliazer
    required init(repository: IJBCustomerListRepository,
                  coordinator: IJBCustomerListCoordinator,
                  uiModel: IJBCustomerListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateSnapshot(currentSnapshot: JBCustomerListSnapshot,
                        newDatas: [JBCustomerModel]) -> JBCustomerListSnapshot {
        self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension JBCustomerListViewModel {

    func getCustomerList() {
        handleResourceFirestore(
            request: self.repository.getCustomerList(cursor: self.uiModel.getLastCursor(),
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
internal extension JBCustomerListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .playNativeLoading(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [JBCustomerModel]) {
        viewState.value = .updateSnapshot(data: data)
    }

    func viewStateOutputDelegate(orderModel: OrderModel) {
        self.viewState.value = .outputDelegate(orderModel: orderModel)
    }
}

// MARK: Coordinate
internal extension JBCustomerListViewModel {

    func presentNewJBCustomerViewController(passData: NewJBCustomerPassData) {
        self.coordinator.presentNewJBCustomerViewController(passData: passData,
                                                            outputDelegate: self)
    }

    func presentJBCustomerPriceViewController(passData: JBCustomerPricePassData) {
        self.coordinator.presentJBCustomerPriceViewController(passData: passData,
                                                              outputDelegate: self)
    }

    func pushArchiveListViewController(jbCustomerId: String) {
        let data = ArchiveListPassData(imagePageType: .order(jbCustomerId: jbCustomerId,
                                                             orderId: "",
                                                             orderName: ""))
        self.coordinator.pushArchiveListViewController(passData: data)
    }
    
    func pushJBCustomerHistoryViewController(passData: JBCustomerHistoryPassData) {
        self.coordinator.pushJBCustomerHistoryViewController(passData: passData)
    }

    func presentNewOrderViewController(passData: NewOrderPassData) {
        self.coordinator.presentNewOrderViewController(passData: passData,
                                                       outputDelegate: self)
    }

    func presentSeasonsViewController(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.coordinator.presentSeasonsViewController(seasonDismissCallback: { [unowned self] isSelected in
            DispatchQueue.delay(200) { [unowned self] in
                self.pushJBCustomerHistoryViewController(passData: JBCustomerHistoryPassData(season: isSelected, customerModel: uiModel.customerModel))
            }
        })
    }

    func popToRootViewController(animated: Bool) {
        self.coordinator.popToRootViewController(animated: animated)
    }
}

// MARK: NewJBCustomerViewControllerOutputDelegate
internal extension JBCustomerListViewModel {

    func newJBCustomerData(_ data: JBCustomerModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: JBCustomerPriceViewControllerOutputDelegate
internal extension JBCustomerListViewModel {

    func getJBCProductAndPrice(stockModel: StockModel, subStockModel: SubStockModel, price: Double) {
        
    }
}

// MARK: NewOrderViewControllerOutputDelegate
internal extension JBCustomerListViewModel {

    func newOrderItemData(_ data: OrderModel) {
        self.viewStateOutputDelegate(orderModel: data)
        self.popToRootViewController(animated: true)
    }
}

// MARK: JBCustomerListDataSourceFactoryOutputDelegate
extension JBCustomerListViewModel {

    func phoneNumberTapped(phoneNumber: String) {
        PhoneCallHelper.shared.makeACall(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: IJBCustomerListTableViewCellUIModel) {
        if !self.uiModel.isCancellableCellTabbed {
            let data = NewOrderPassData(customerModel: uiModel.customerModel)
            self.presentNewOrderViewController(passData: data)
        }
    }

    func priceTapped(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.presentJBCustomerPriceViewController(
            passData: JBCustomerPricePassData(isPriceSelectable: false,
                                              customerModel: uiModel.customerModel)
        )
    }

    func archiveTapped(customerId: String) {
        self.pushArchiveListViewController(jbCustomerId: customerId)
    }

    func updateTapped(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.presentNewJBCustomerViewController(passData: NewJBCustomerPassData(customerInformation: uiModel))
    }

    func pastTapped(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.presentSeasonsViewController(uiModel: uiModel)
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getCustomerList()
        }
    }
}

enum JBCustomerListViewState {
    case playNativeLoading(isProgress: Bool)
    case buildSnapshot(snapshot: JBCustomerListSnapshot)
    case updateSnapshot(data: [JBCustomerModel])
    case outputDelegate(orderModel: OrderModel)
}
