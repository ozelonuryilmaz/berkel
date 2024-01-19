//
//  NewCavusViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import Combine

protocol INewCavusViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewCavusViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewCavusRepository,
         coordinator: INewCavusCoordinator,
         uiModel: INewCavusUIModel)

    func initData()
    func viewWillAppear()

    // Coordinate
    func dismiss()

    // Setter
    func setName(_ name: String)
    func setPhone(_ phone: String)
    func setDesc(_ desc: String)

    // Service
    func saveNewCavus()
}

final class NewCavusViewModel: BaseViewModel, INewCavusViewModel {

    // MARK: Definitions
    private let repository: INewCavusRepository
    private let coordinator: INewCavusCoordinator
    private var uiModel: INewCavusUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewCavusViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<CavusModel?, Never>(nil)
    let updateResponse = CurrentValueSubject<Bool?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewCavusRepository,
                  coordinator: INewCavusCoordinator,
                  uiModel: INewCavusUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initData() {
        if self.uiModel.isUpdatedCavus {
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
internal extension NewCavusViewModel {

    func saveNewCavus() {
        if self.uiModel.isUpdatedCavus {
            self.updateCavus()
        } else {
            self.addNewCavus()
        }
    }

    private func addNewCavus() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewCavus(data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSavedCavus()
                self.dismiss()
            })
    }

    private func updateCavus() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.updateCavus(data: self.uiModel.data),
            response: self.updateResponse,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSavedCavus()
                self.dismiss()
            })
    }
}

// MARK: States
internal extension NewCavusViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateShowSavedCavus() {
        viewState.value = .showSavedCavus(data: self.response.value != nil ? self.response.value! : self.uiModel.data)

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
internal extension NewCavusViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum NewCavusViewState {
    case showNativeProgress(isProgress: Bool)
    case showSavedCavus(data: CavusModel)
    case updateNavigationTitle(title: String)
    case disableNameTextField
    case initData(name: String, phoneNumber: String, desc: String)
}
