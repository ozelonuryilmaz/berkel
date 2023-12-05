//
//  CustomerListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import Combine

protocol ICustomerListViewModel: NewCustomerViewControllerOutputDelegate, CustomerListDataSourceFactoryOutputDelegate, NewSellerViewControllerOutputDelegate{

    var viewState: ScreenStateSubject<CustomerListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ICustomerListRepository,
         coordinator: ICustomerListCoordinator,
         uiModel: ICustomerListUIModel)

    // Coordinate
    func presentNewCustomerViewController()
    
    // Service
    func getCustomerList()
    
    func updateSnapshot(currentSnapshot: CustomerListSnapshot,
                        newDatas: [CustomerModel]) -> CustomerListSnapshot
}

final class CustomerListViewModel: BaseViewModel, ICustomerListViewModel {

    // MARK: Definitions
    private let repository: ICustomerListRepository
    private let coordinator: ICustomerListCoordinator
    private var uiModel: ICustomerListUIModel

    // MARK: Private Props
    private var isLastPage: Bool = false
    private var isAvailablePagination: Bool = false

    // MARK: Public Props
    var viewState = ScreenStateSubject<CustomerListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<[CustomerModel]?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ICustomerListRepository,
                  coordinator: ICustomerListCoordinator,
                  uiModel: ICustomerListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func updateSnapshot(currentSnapshot: CustomerListSnapshot,
                        newDatas: [CustomerModel]) -> CustomerListSnapshot {
        self.uiModel.updateSnapshot(currentSnapshot: currentSnapshot, newDatas: newDatas)
    }
}


// MARK: Service
internal extension CustomerListViewModel {

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
internal extension CustomerListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateBuildSnapshot() {
        viewState.value = .buildSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

    func viewStateUpdateSnapshot(data: [CustomerModel]) {
        viewState.value = .updateSnapshot(data: data)
    }

    func viewStateOutputDelegate(sellerModel: SellerModel) {
        self.viewState.value = .outputDelegate(sellerModel: sellerModel)
    }
}

// MARK: Coordinate
internal extension CustomerListViewModel {

    func presentNewCustomerViewController() {
        self.coordinator.presentNewCustomerViewController(passData: NewCustomerPassData(),
                                                          outputDelegate: self)
    }

    func presentNewSellerViewController(customerId: String, customerName: String) {
        self.coordinator.presentNewSellerViewController(passData: NewSellerPassData(customerId: customerId, customerName: customerName), outputDelegate: self)
    }

    func popToRootViewController(animated: Bool) {
        self.coordinator.popToRootViewController(animated: animated)
    }
    
    func pushArchiveListViewController(customerId: String) {
        // MARK: sellerId kullanılmıyor
        let data = ArchiveListPassData(imagePageType: .seller(customerId: customerId,
                                                              sellerId: "",
                                                              sellerProductName: ""))
        self.coordinator.pushArchiveListViewController(passData: data)
    }
}

// MARK: NewCustomerViewControllerOutputDelegate
internal extension CustomerListViewModel {

    func newCustomerData(_ data: CustomerModel) {
        self.uiModel.appendFirstItem(data: data)
        self.viewStateBuildSnapshot()
    }
}

// MARK: CustomerListDataSourceFactoryOutputDelegate
extension CustomerListViewModel {

    func phoneNumberTapped(phoneNumber: String) {
        PhoneCallHelper.shared.makeACall(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: ICustomerListTableViewCellUIModel) {
        self.presentNewSellerViewController(customerId: uiModel.id ?? "", customerName: uiModel.name)
    }
    
    func archiveTapped(customerId: String) {
        self.pushArchiveListViewController(customerId: customerId)
    }

    func scrollDidScroll(isAvailablePagination: Bool) {
        if self.isAvailablePagination && isAvailablePagination && !isLastPage {
            self.getCustomerList()
        }
    }
}

// MARK: NewSellerViewControllerOutputDelegate
internal extension CustomerListViewModel {

    func newSellerData(_ data: SellerModel) {
        self.viewStateOutputDelegate(sellerModel: data)
        self.popToRootViewController(animated: true)
    }
}


enum CustomerListViewState {
    case showNativeProgress(isProgress: Bool)
    case buildSnapshot(snapshot: CustomerListSnapshot)
    case updateSnapshot(data: [CustomerModel])
    case outputDelegate(sellerModel: SellerModel)
}
