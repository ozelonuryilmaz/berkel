//
//  NewWarehouseViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//

import Foundation
import Combine

protocol INewWarehouseViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewWarehouseViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewWarehouseRepository,
         coordinator: INewWarehouseCoordinator,
         uiModel: INewWarehouseUIModel,
         successDismissCallBack: ((_ data: WarehouseModel) -> Void)?)

    func initComponents()

    // Setter
    func setDate(date: String?)
    func setKg(_ text: String)
    func setPrice(_ text: String)
    func setDesc(_ text: String)

    // ViewState
    func viewStateSetNavigationTitle()

    // Service
    func saveWarehouse()
}

final class NewWarehouseViewModel: BaseViewModel, INewWarehouseViewModel {

    // MARK: Definitions
    private let repository: INewWarehouseRepository
    private let coordinator: INewWarehouseCoordinator
    private var uiModel: INewWarehouseUIModel
    var successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil

    // MARK: Private Props

    // MARK: Public Props

    var viewState = ScreenStateSubject<NewWarehouseViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<WarehouseModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewWarehouseRepository,
                  coordinator: INewWarehouseCoordinator,
                  uiModel: INewWarehouseUIModel,
                  successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.successDismissCallBack = successDismissCallBack
    }

    func initComponents() {
        self.viewStateSellerName()
    }
}


// MARK: Service
internal extension NewWarehouseViewModel {

    func saveWarehouse() {
        guard self.uiModel.isHaveAnyResults else { return }
        guard let buyingId = self.uiModel.buyingId, let collectionId = self.uiModel.collectionId else { return }

        handleResourceFirestore(
            request: self.repository.saveNewWarehouse(season: self.uiModel.season,
                                                      buyingId: buyingId,
                                                      collectionId: collectionId,
                                                      data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self, let data = self.response.value else { return }
                self.successDismiss(data: data)
            })
    }
}

// MARK: States
internal extension NewWarehouseViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.date ?? "",
                                                   subTitle: "Depo Çıkması Ekle")
    }

    func viewStateSellerName() {
        self.viewState.value = .setSellerAndProductName(seller: self.uiModel.sellerName,
                                                        product: self.uiModel.productName)
    }
}

// MARK: Coordinate
internal extension NewWarehouseViewModel {

    func successDismiss(data: WarehouseModel) {
        self.successDismissCallBack?(data)
        self.coordinator.selfPopViewController()
    }
}

// MARK: Setter
internal extension NewWarehouseViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setKg(_ text: String) {
        self.uiModel.setKg(text)
    }

    func setPrice(_ text: String) {
        self.uiModel.setPrice(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }

}

enum NewWarehouseViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String, subTitle: String)
    case setSellerAndProductName(seller: String, product: String)
}
