//
//  NewOtherItemViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol INewOtherItemViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewOtherItemViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewOtherItemRepository,
         coordinator: INewOtherItemCoordinator,
         uiModel: INewOtherItemUIModel)

    func initComponents()
    
    // Service
    func saveNewOther()
    
    // Coordinate
    func dismiss(completion: (() -> Void)?)
    
    // Setter
    func setDesc(_ value: String)
}

final class NewOtherItemViewModel: BaseViewModel, INewOtherItemViewModel {

    // MARK: Definitions
    private let repository: INewOtherItemRepository
    private let coordinator: INewOtherItemCoordinator
    private var uiModel: INewOtherItemUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<NewOtherItemViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseOther = CurrentValueSubject<OtherModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewOtherItemRepository,
                  coordinator: INewOtherItemCoordinator,
                  uiModel: INewOtherItemUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    func initComponents() {
        self.viewStateOtherSellerName()
    }
}


// MARK: Service
internal extension NewOtherItemViewModel {

    func saveNewOther() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.saveNewOther(data: self.uiModel.newOtherData,
                                                season: self.uiModel.season),
            response: self.responseOther,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let response = self.responseOther.value else { return }
                self.dismiss(completion: {
                    self.viewStateOutputDelegate(otherModel: response)
                })
                
            })
    }
}

// MARK: States
internal extension NewOtherItemViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateOutputDelegate(otherModel: OtherModel) {
        self.viewState.value = .outputDelegate(otherModel: otherModel)
    }

    func viewStateOtherSellerName() {
        self.viewState.value = .setOtherSellerName(name: self.uiModel.otherSellerName,
                                                   categoryName: self.uiModel.otherSellerCategoryName)
    }
}

// MARK: Coordinate
internal extension NewOtherItemViewModel {

    func dismiss(completion: (() -> Void)?) {
        self.coordinator.dismiss(completion: completion)
    }
}

// MARK: Setter
internal extension NewOtherItemViewModel {

    func setDesc(_ value: String) {
        self.uiModel.setDesc(value)
    }
}

enum NewOtherItemViewState {
    case showNativeProgress(isProgress: Bool)
    case outputDelegate(otherModel: OtherModel)
    case setOtherSellerName(name: String,
                            categoryName: String)
}
