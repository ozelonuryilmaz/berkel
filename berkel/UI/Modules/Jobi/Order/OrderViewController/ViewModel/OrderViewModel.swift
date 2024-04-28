//
//  OrderViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Combine

protocol IOrderViewModel: JBCustomerListViewControllerOutputDelegate,
    OrderDetailViewControllerOutputDelegate,
    OrderDataSourceFactoryOutputDelegate,
    OrderCollectionViewControllerOutputDelegate,
    OrderPaymentViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<OrderViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IOrderRepository,
         coordinator: IOrderCoordinator,
         uiModel: IOrderUIModel)

    // Coordinator
    func pushJBCustomerListViewController()

    // Service
    func getOrder()

    // DataSource
    func updateSnapshot(currentSnapshot: OrderSnapshot,
                        newDatas: [OrderModel]) -> OrderSnapshot
}

final class OrderViewModel: BaseViewModel, IOrderViewModel {

    // MARK: Definitions
    private let repository: IOrderRepository
    private let coordinator: IOrderCoordinator
    private var uiModel: IOrderUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OrderViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[OrderModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOrderRepository,
                  coordinator: IOrderCoordinator,
                  uiModel: IOrderUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var season: String {
        return uiModel.season
    }

    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    func updateSnapshot(currentSnapshot: OrderSnapshot,
                        newDatas: [OrderModel]) -> OrderSnapshot {
        return self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension OrderViewModel {

    func getOrder() {

        handleResourceFirestore(
            request: self.repository.getOrderList(season: self.uiModel.season,
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
internal extension OrderViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [OrderModel]) {
        viewState.value = .updateSnapshot(data: data)
    }
}

// MARK: Coordinate
internal extension OrderViewModel {

    func pushJBCustomerListViewController() {
        self.coordinator.pushJBCustomerListViewController(passData: JBCustomerListPassData(),
                                                          outputDelegate: self)
    }

    func presentOrderCollectionViewController(passData: OrderCollectionPassData) {
        self.coordinator.presentOrderCollectionViewController(passData: passData,
                                                              outputDelegate: self)
    }

    func presentOrderPaymentViewController(passData: OrderPaymentPassData) {
        self.coordinator.presentOrderPaymentViewController(passData: passData,
                                                           outputDelegate: self)
    }
}

// MARK: JBCustomerListViewControllerOutputDelegate
internal extension OrderViewModel {

    func newOrderData(_ data: OrderModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: OrderDataSourceFactoryOutputDelegate
internal extension OrderViewModel {

    func cellTapped(uiModel: IOrderTableViewCellUIModel) {
        /*let data = OrderDetailPassData(orderId: uiModel.orderId,
                                       orderSellerName: uiModel.orderSellerName,
                                       orderSellerId: uiModel.orderSellerId,
                                       isActive: uiModel.isActive,
                                       categoryName: uiModel.categoryName,
                                       categoryId: uiModel.categoryId)
        self.pushOrderDetailViewController(passData: data)*/
    }

    func addCollectionTapped(uiModel: IOrderTableViewCellUIModel) {
        let passData = OrderCollectionPassData(orderModel: uiModel.orderModel)
        self.presentOrderCollectionViewController(passData: passData)
    }

    func addPaymentTapped(uiModel: IOrderTableViewCellUIModel) {
        let passData = OrderPaymentPassData(orderModel: uiModel.orderModel)
        self.presentOrderPaymentViewController(passData: passData)
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getOrder()
        }
    }
}

// MARK: OrderDetailViewControllerOutputDelegate
internal extension OrderViewModel {

    func closeButtonTapped(orderId: String, isActive: Bool) {

    }
}

// MARK: OrderCollectionViewControllerOutputDelegate
internal extension OrderViewModel { }

// MARK: OrderPaymentViewControllerOutputDelegate
internal extension OrderViewModel { }

enum OrderViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: OrderSnapshot)
    case updateSnapshot(data: [OrderModel])
}
