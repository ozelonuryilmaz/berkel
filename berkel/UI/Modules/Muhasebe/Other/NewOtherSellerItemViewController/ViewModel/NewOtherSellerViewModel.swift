//
//  NewOtherSellerViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol INewOtherSellerViewModel: OtherSellerCategoryListViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<NewOtherSellerViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewOtherSellerRepository,
         coordinator: INewOtherSellerCoordinator,
         uiModel: INewOtherSellerUIModel)

    func initData()
    func viewWillAppear()

    // Coordinate
    func dismiss()
    func presentOtherSellerCategoryListViewController()

    // Setter
    func setName(_ name: String)
    func setPhone(_ phone: String)
    func setDesc(_ desc: String)

    // Service
    func saveNewOtherSeller()
}

final class NewOtherSellerViewModel: BaseViewModel, INewOtherSellerViewModel {

    // MARK: Definitions
    private let repository: INewOtherSellerRepository
    private let coordinator: INewOtherSellerCoordinator
    private var uiModel: INewOtherSellerUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewOtherSellerViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<OtherSellerModel?, Never>(nil)
    let updateResponse = CurrentValueSubject<Bool?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewOtherSellerRepository,
                  coordinator: INewOtherSellerCoordinator,
                  uiModel: INewOtherSellerUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initData() {

        if self.uiModel.isUpdatedOtherSeller {
            self.viewStateDisableNameTextField()
            self.viewStateInitData()
        }
    }

    func viewWillAppear() {
        self.viewStateUpdateNavigationTitle()
    }

    func setCategory(id: String, name: String) {
        self.uiModel.setCategory(id: id, name: name)
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
internal extension NewOtherSellerViewModel {

    func saveNewOtherSeller() {
        if self.uiModel.isUpdatedOtherSeller {
            self.updateNewOtherSeller()
        } else {
            self.addNewOtherSeller()
        }
    }

    private func addNewOtherSeller() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewOtherSeller(data: self.uiModel.data),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSavedOtherSeller()
                self.dismiss()
            })
    }

    private func updateNewOtherSeller() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.updateOtherSeller(data: self.uiModel.data),
            response: self.updateResponse,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.viewStateShowSavedOtherSeller()
                self.dismiss()
            })
    }

}

// MARK: States
internal extension NewOtherSellerViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateShowSavedOtherSeller() {
        viewState.value = .showSavedOtherSeller(data: self.response.value != nil ? self.response.value! : self.uiModel.data)
    }

    func viewStateUpdateNavigationTitle() {
        viewState.value = .updateNavigationTitle(title: self.uiModel.navigationTitle)
    }

    func viewStateDisableNameTextField() {
        viewState.value = .disableNameTextField
    }

    func viewStateInitData() {
        viewState.value = .initData(categoryName: self.uiModel.getCategoryName(),
                                    name: self.uiModel.getName(),
                                    phoneNumber: self.uiModel.getPhone(),
                                    desc: self.uiModel.getDesc())
    }

    func viewStateCategoryName(name: String) {
        self.viewState.value = .setCategoryName(name: name)
    }
}

// MARK: Coordinate
internal extension NewOtherSellerViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }

    func presentOtherSellerCategoryListViewController() {
        self.coordinator.presentOtherSellerCategoryListViewController(outputDelegate: self)
    }
}

// MARK: OtherSellerCategoryListViewControllerOutputDelegate
internal extension NewOtherSellerViewModel {

    func getSelectionOtherSellerCategory(id: String, name: String) {
        self.setCategory(id: id, name: name)
        self.viewStateCategoryName(name: name)
    }
}

enum NewOtherSellerViewState {
    case showNativeProgress(isProgress: Bool)
    case showSavedOtherSeller(data: OtherSellerModel)
    case updateNavigationTitle(title: String)
    case disableNameTextField
    case initData(categoryName: String, name: String, phoneNumber: String, desc: String)
    case setCategoryName(name: String)
}
