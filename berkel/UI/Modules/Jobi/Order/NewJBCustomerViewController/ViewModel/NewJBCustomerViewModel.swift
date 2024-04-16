//
//  NewJBCustomerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol INewJBCustomerViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewJBCustomerViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewJBCustomerRepository,
         coordinator: INewJBCustomerCoordinator,
         uiModel: INewJBCustomerUIModel)

    func initData()
    func viewWillAppear()

    // Coordinate
    func dismiss()

    // Setter
    func setName(_ name: String)
    func setPhone(_ phone: String)
    func setDesc(_ desc: String)

    // Service
    func saveNewCustomer()
}

final class NewJBCustomerViewModel: BaseViewModel, INewJBCustomerViewModel {

    // MARK: Definitions
    private let repository: INewJBCustomerRepository
    private let coordinator: INewJBCustomerCoordinator
    private var uiModel: INewJBCustomerUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<NewJBCustomerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<JBCustomerModel?, Never>(nil)
    let updateResponse = CurrentValueSubject<Bool?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewJBCustomerRepository,
                  coordinator: INewJBCustomerCoordinator,
                  uiModel: INewJBCustomerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initData() {
        if self.uiModel.isUpdatedCustomer {
            self.viewStateDisableNameTextField()
            self.viewStateInitData()
        }
    }

    func viewWillAppear() {
        self.viewStateUpdateNavigationTitle()
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
internal extension NewJBCustomerViewModel {

    func saveNewCustomer() {
        if self.uiModel.isUpdatedCustomer {
            self.updateCustomer()
        } else {
            self.addNewCustomer()
        }
    }

    private func addNewCustomer() {
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

    private func updateCustomer() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.updateCustomer(data: self.uiModel.data),
            response: self.updateResponse,
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
internal extension NewJBCustomerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateShowSavedCustomer() {
        viewState.value = .showSavedCustomer(data: self.response.value != nil ? self.response.value! : self.uiModel.data)

    }

    func viewStateUpdateNavigationTitle() {
        viewState.value = .updateNavigationTitle(title: self.uiModel.navigationTitle)
    }

    func viewStateDisableNameTextField() {
        viewState.value = .disableNameTextField
    }

    func viewStateInitData() {
        viewState.value = .initData(name: self.uiModel.getName(),
                                    phoneNumber: self.uiModel.getPhone(),
                                    desc: self.uiModel.getDesc())
    }
}

// MARK: Coordinate
internal extension NewJBCustomerViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

enum NewJBCustomerViewState {
    case showNativeProgress(isProgress: Bool)
    case showSavedCustomer(data: JBCustomerModel)
    case updateNavigationTitle(title: String)
    case disableNameTextField
    case initData(name: String, phoneNumber: String, desc: String)
}
