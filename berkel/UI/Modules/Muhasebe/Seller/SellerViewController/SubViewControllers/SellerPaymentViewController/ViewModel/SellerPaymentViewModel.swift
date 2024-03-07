//
//  SellerPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 24.11.2023.
//

import Combine

protocol ISellerPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<SellerPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: ISellerPaymentRepository,
         coordinator: ISellerPaymentCoordinator,
         uiModel: ISellerPaymentUIModel)

    func initComponents()
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setPayment(_ text: String)
    func setDesc(_ text: String)

    // Service
    func savePayment()
}

final class SellerPaymentViewModel: BaseViewModel, ISellerPaymentViewModel {

    // MARK: Definitions
    private let repository: ISellerPaymentRepository
    private let coordinator: ISellerPaymentCoordinator
    private var uiModel: ISellerPaymentUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<SellerPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<SellerPaymentModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: ISellerPaymentRepository,
                  coordinator: ISellerPaymentCoordinator,
                  uiModel: ISellerPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateProductName()
        self.viewStateCustomerName()
    }
}


// MARK: Service
internal extension SellerPaymentViewModel {

    func savePayment() {
        guard self.uiModel.payment > 0 else { return }

        handleResourceFirestore(
            request: self.repository.saveNewPayment(season: self.uiModel.season,
                                                    sellerId: self.uiModel.sellerId,
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
internal extension SellerPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateProductName() {
        self.viewState.value = .productName(name: self.uiModel.productName)
    }

    func viewStateCustomerName() {
        self.viewState.value = .customerName(name: self.uiModel.customerName)
    }

}

// MARK: Coordinate
internal extension SellerPaymentViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension SellerPaymentViewModel {

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

enum SellerPaymentViewState {
    case showNativeProgress(isProgress: Bool)
    case productName(name: String)
    case customerName(name: String)
}
