//
//  BuyingPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//

import Combine

protocol IBuyingPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<BuyingPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IBuyingPaymentRepository,
         coordinator: IBuyingPaymentCoordinator,
         uiModel: IBuyingPaymentUIModel)

    func initComponents()
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setPayment(_ text: String)
    func setDesc(_ text: String)

    // Service
    func savePayment()
}

final class BuyingPaymentViewModel: BaseViewModel, IBuyingPaymentViewModel {

    // MARK: Definitions
    private let repository: IBuyingPaymentRepository
    private let coordinator: IBuyingPaymentCoordinator
    private var uiModel: IBuyingPaymentUIModel

    // MARK: Private Props

    // MARK: Public Props
    var viewState = ScreenStateSubject<BuyingPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<NewBuyingPaymentModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IBuyingPaymentRepository,
                  coordinator: IBuyingPaymentCoordinator,
                  uiModel: IBuyingPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateSellerName()
    }
}


// MARK: Service
internal extension BuyingPaymentViewModel {

    func savePayment() {
        guard self.uiModel.payment > 0 else { return }

        handleResourceFirestore(
            request: self.repository.saveNewPayment(season: self.uiModel.season,
                                                    buyingId: self.uiModel.buyingId,
                                                    data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.dismiss()
            })
    }
}

// MARK: States
internal extension BuyingPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSellerName() {
        self.viewState.value = .setSellerAndProductName(seller: self.uiModel.sellerName,
                                                        product: self.uiModel.productName)
    }
}

// MARK: Coordinate
internal extension BuyingPaymentViewModel {


    func dismiss() {
        self.coordinator.dismiss()
    }
}

// MARK: Setter
internal extension BuyingPaymentViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setPayment(_ text: String) {
        self.uiModel.setPayment(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }

}


enum BuyingPaymentViewState {
    case showNativeProgress(isProgress: Bool)
    case setSellerAndProductName(seller: String, product: String)
}


