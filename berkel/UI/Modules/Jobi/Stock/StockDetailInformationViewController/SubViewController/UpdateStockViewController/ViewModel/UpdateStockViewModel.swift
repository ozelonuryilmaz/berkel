//
//  UpdateStockViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import Foundation
import Combine

protocol IUpdateStockViewModel: AnyObject {

    var viewState: ScreenStateSubject<UpdateStockViewState> { get }
    var errorState: ErrorStateSubject { get }
    
    var navigationTitle: String { get }
    var navigationSubTitle: String { get }

    init(repository: IUpdateStockRepository,
         coordinator: IUpdateStockCoordinator,
         uiModel: IUpdateStockUIModel)
    
    func initComponents()
    func dismiss()

    // Setter
    func setDate(date: String?)
    func setCount(_ text: String)
    func setDesc(_ text: String)

    // Service
    func saveStock()
}

final class UpdateStockViewModel: BaseViewModel, IUpdateStockViewModel {

    // MARK: Definitions
    private let repository: IUpdateStockRepository
    private let coordinator: IUpdateStockCoordinator
    private var uiModel: IUpdateStockUIModel

    // MARK: Private Props
    var viewState = ScreenStateSubject<UpdateStockViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IUpdateStockRepository,
                  coordinator: IUpdateStockCoordinator,
                  uiModel: IUpdateStockUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }
    
    func initComponents() {
        self.viewStateSetButtonTitle()
    }

    var navigationTitle: String {
        return uiModel.navigationTitle
    }

    var navigationSubTitle: String {
        return uiModel.navigationSubTitle
    }
}


// MARK: Service
internal extension UpdateStockViewModel {

    func saveStock() {
        
    }
}

// MARK: States
internal extension UpdateStockViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }
    
    func viewStateSetButtonTitle() {
        viewState.value = .setButtonTitle(title: uiModel.buttonTitle)
    }

}

// MARK: Coordinate
internal extension UpdateStockViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }
}

// MARK: Setter
internal extension UpdateStockViewModel {

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

enum UpdateStockViewState {
    case showNativeProgress(isProgress: Bool)
    case setButtonTitle(title: String)
}
