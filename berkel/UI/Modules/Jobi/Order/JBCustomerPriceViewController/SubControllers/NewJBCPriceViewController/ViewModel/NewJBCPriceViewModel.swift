//
//  NewJBCPriceViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol INewJBCPriceViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewJBCPriceViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewJBCPriceRepository,
         coordinator: INewJBCPriceCoordinator,
         uiModel: INewJBCPriceUIModel)
    
    var navTitle: String { get }
    
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setCount(_ text: String)
    func setDesc(_ text: String)

    // Service
    func savePrice()
}

final class NewJBCPriceViewModel: BaseViewModel, INewJBCPriceViewModel {

    // MARK: Definitions
    private let repository: INewJBCPriceRepository
    private let coordinator: INewJBCPriceCoordinator
    private var uiModel: INewJBCPriceUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<NewJBCPriceViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let response = CurrentValueSubject<JBCPriceModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: INewJBCPriceRepository,
                  coordinator: INewJBCPriceCoordinator,
                  uiModel: INewJBCPriceUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }
    
    var navTitle: String {
        return uiModel.navTitle
    }
}


// MARK: Service
internal extension NewJBCPriceViewModel {

    func savePrice() {
        if let errorMessage = self.uiModel.errorMessage {
            errorState.value = .ERROR_MESSAGE(title: "Uyarı", msg: errorMessage)
            return
        }

        handleResourceFirestore(
            request: self.repository.savePrice(data: uiModel.data, season: uiModel.season),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self, let data = self.response.value else { return }
                self.viewStateShowSavedJBCPriceData(data: data)
                self.dismiss()
            })
    }
}

// MARK: States
internal extension NewJBCPriceViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateShowSystemAlert(title: String, message: String) {
        viewState.value = .showSystemAlert(title: title, message: message)
    }

    func viewStateShowSavedJBCPriceData(data: JBCPriceModel) {
        viewState.value = .showSavedJBCPriceData(data: data)
    }
}

// MARK: Coordinate
internal extension NewJBCPriceViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension NewJBCPriceViewModel {

    func setDate(date: String?) {
        self.uiModel.setDate(date: date)
    }

    func setCount(_ text: String) {
        self.uiModel.setCount(text)
    }

    func setDesc(_ text: String) {
        self.uiModel.setDesc(text)
    }
}

enum NewJBCPriceViewState {
    case showNativeProgress(isProgress: Bool)
    case showSystemAlert(title: String, message: String)
    case showSavedJBCPriceData(data: JBCPriceModel)
}
