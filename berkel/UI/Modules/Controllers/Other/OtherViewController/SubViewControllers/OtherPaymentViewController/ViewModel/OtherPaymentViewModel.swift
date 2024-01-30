//
//  OtherPaymentViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 30.01.2024.
//

import Combine

protocol IOtherPaymentViewModel: AnyObject {

    var viewState: ScreenStateSubject<OtherPaymentViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IOtherPaymentRepository,
         coordinator: IOtherPaymentCoordinator,
         uiModel: IOtherPaymentUIModel)
    
    func initComponents()
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setPayment(_ text: String)
    func setDesc(_ text: String)

    // Service
    func savePayment()
}

final class OtherPaymentViewModel: BaseViewModel, IOtherPaymentViewModel {

    // MARK: Definitions
    private let repository: IOtherPaymentRepository
    private let coordinator: IOtherPaymentCoordinator
    private var uiModel: IOtherPaymentUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherPaymentViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<OtherPaymentModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOtherPaymentRepository,
                  coordinator: IOtherPaymentCoordinator,
                  uiModel: IOtherPaymentUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateCategoryName()
        self.viewStateOtherSellerName()
    }
}


// MARK: Service
internal extension OtherPaymentViewModel {

    func savePayment() {
        guard self.uiModel.payment > 0 else { return }

        handleResourceFirestore(
            request: self.repository.saveNewPayment(season: self.uiModel.season,
                                                    otherId: self.uiModel.otherId,
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
internal extension OtherPaymentViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateCategoryName() {
        self.viewState.value = .categoryName(name: self.uiModel.categoryName)
    }

    func viewStateOtherSellerName() {
        self.viewState.value = .otherSellerName(name: self.uiModel.otherSellerName)
    }
}

// MARK: Coordinate
internal extension OtherPaymentViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension OtherPaymentViewModel {

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

enum OtherPaymentViewState {
    case showNativeProgress(isProgress: Bool)
    case categoryName(name: String)
    case otherSellerName(name: String)
}
