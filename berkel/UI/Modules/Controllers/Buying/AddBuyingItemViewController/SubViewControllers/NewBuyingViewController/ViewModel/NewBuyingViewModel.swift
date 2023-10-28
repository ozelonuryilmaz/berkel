//
//  NewBuyingViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//

import Combine

protocol INewBuyingViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewBuyingViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewBuyingRepository,
         coordinator: INewBuyingCoordinator,
         uiModel: INewBuyingUIModel,
         successDismissCallBack: ((_ data: NewBuyingModel) -> Void)?)

    func initComponents()

    // Setter
    func setProduct(_ product: String)
    func setPrice(_ price: String)
    func setPayment(_ payment: String)
    func setDesc(_ desc: String)

    // Service
    func saveNewBuying()

    // Coordinator
    func dismiss()
}

final class NewBuyingViewModel: BaseViewModel, INewBuyingViewModel {

    // MARK: Definitions
    private let repository: INewBuyingRepository
    private let coordinator: INewBuyingCoordinator
    private var uiModel: INewBuyingUIModel
    var successDismissCallBack: ((_ data: NewBuyingModel) -> Void)? = nil

    // MARK: Private Props

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewBuyingViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseBuying = CurrentValueSubject<NewBuyingModel?, Never>(nil)
    let responsePayment = CurrentValueSubject<NewBuyingPaymentModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewBuyingRepository,
                  coordinator: INewBuyingCoordinator,
                  uiModel: INewBuyingUIModel,
                  successDismissCallBack: ((_ data: NewBuyingModel) -> Void)?) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.successDismissCallBack = successDismissCallBack
    }

    func initComponents() {
        self.viewStateSellerName()
        self.viewStateSellerTCKN()
    }
}


// MARK: Service
internal extension NewBuyingViewModel {

    func saveNewBuying() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewBuying(data: self.uiModel.newBuyingData,
                                                   season: self.uiModel.season),
            response: self.responseBuying,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let buyingId = self.responseBuying.value?.id else { return }

                self.saveFirstPayment(buyingId: buyingId)
            })
    }

    private func saveFirstPayment(buyingId: String) {
        handleResourceFirestore(
            request: self.repository.savePayment(data: self.uiModel.firstPayment,
                                                 season: self.uiModel.season,
                                                 buyingId: buyingId),
            response: self.responsePayment,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let buyingData = self.responseBuying.value else { return }

                self.successDismiss(data: buyingData)
            })
    }
}

// MARK: States
internal extension NewBuyingViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSellerName() {
        self.viewState.value = .setSellerName(name: self.uiModel.sellerName)
    }

    func viewStateSellerTCKN() {
        self.viewState.value = .setSellerTCKN(tckn: self.uiModel.sellerTCKN)
    }

    // MARK: Action State

}

// MARK: Coordinate
internal extension NewBuyingViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }

    func successDismiss(data: NewBuyingModel) {
        self.coordinator.dismiss(completion: { [weak self] in
            self?.successDismissCallBack?(data)
        })
    }
}

// MARK: Setter
internal extension NewBuyingViewModel {

    func setProduct(_ product: String) {
        self.uiModel.setProduct(product)
    }

    func setPrice(_ price: String) {
        self.uiModel.setPrice(price)
    }

    func setPayment(_ payment: String) {
        self.uiModel.setPayment(payment)
    }

    func setDesc(_ desc: String) {
        self.uiModel.setDesc(desc)
    }
}


enum NewBuyingViewState {

    case showNativeProgress(isProgress: Bool)
    case setSellerName(name: String)
    case setSellerTCKN(tckn: String)
}
