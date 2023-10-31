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

    // MARK: Initiliazer
    required init(repository: INewCavusRepository,
                  coordinator: INewCavusCoordinator,
                  uiModel: INewCavusUIModel) {
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
internal extension NewCavusViewModel {

    func saveNewCavus() {
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
                //self.viewStateShowNewCavus()
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

}

// MARK: Coordinate
internal extension NewCavusViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}


enum NewCavusViewState {
    case showNativeProgress(isProgress: Bool)
}
