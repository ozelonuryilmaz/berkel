//
//  NewCustomerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import Combine

protocol INewCustomerViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewCustomerViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewCustomerRepository,
         coordinator: INewCustomerCoordinator,
         uiModel: INewCustomerUIModel)
    
    // Coordinate
    func dismiss()
    
    // Setter
    func setName(_ name: String)
    func setPhone(_ phone: String)
    func setDesc(_ desc: String)
    
    // Service
    func saveNewCustomer()
}

final class NewCustomerViewModel: BaseViewModel, INewCustomerViewModel {

    // MARK: Definitions
    private let repository: INewCustomerRepository
    private let coordinator: INewCustomerCoordinator
    private var uiModel: INewCustomerUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewCustomerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<CustomerModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewCustomerRepository,
                  coordinator: INewCustomerCoordinator,
                  uiModel: INewCustomerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }
 
    func setName(_ name: String) {
        self.uiModel.setName(name)
    }

    func setPhone(_ phone: String) {
        self.uiModel.setPhone(phone)
    }

    func setDesc(_ desc: String) {
        self.uiModel.setDesc(desc)
    }
}


// MARK: Service
internal extension NewCustomerViewModel {

    func saveNewCustomer() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewCustomer(data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSavedCustomer()
                self.dismiss()
            })
    }
}

// MARK: States
internal extension NewCustomerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateShowSavedCustomer() {
        guard let data = self.response.value else { return }
        viewState.value = .showSavedCustomer(data: data)
    }
}

// MARK: Coordinate
internal extension NewCustomerViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum NewCustomerViewState {
    case showNativeProgress(isProgress: Bool)
    case showSavedCustomer(data: CustomerModel)
}
