//
//  NewWarehouseViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Foundation
import Combine

protocol INewWarehouseViewModel: AnyObject {

    var viewState: ScreenStateSubject<NewWarehouseViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: INewWarehouseRepository,
         coordinator: INewWarehouseCoordinator,
         uiModel: INewWarehouseUIModel,
         successDismissCallBack: ((_ data: WarehouseModel) -> Void)?)

    
    func viewStateSetNavigationTitle()
    
    func initComponents()

}

final class NewWarehouseViewModel: BaseViewModel, INewWarehouseViewModel {

    // MARK: Definitions
    private let repository: INewWarehouseRepository
    private let coordinator: INewWarehouseCoordinator
    private var uiModel: INewWarehouseUIModel
    var successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil

    // MARK: Private Props

    // MARK: Public Props

    var viewState = ScreenStateSubject<NewWarehouseViewState>(nil)
    var errorState = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: INewWarehouseRepository,
                  coordinator: INewWarehouseCoordinator,
                  uiModel: INewWarehouseUIModel,
                  successDismissCallBack: ((_ data: WarehouseModel) -> Void)?) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.successDismissCallBack = successDismissCallBack
    }

    func initComponents() {
        
    }
}


// MARK: Service
internal extension NewWarehouseViewModel {

}

// MARK: States
internal extension NewWarehouseViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }
    
    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.date ?? "",
                                                   subTitle: "Depo Çıkması Ekle")
    }

}

// MARK: Coordinate
internal extension NewWarehouseViewModel {

    func successDismiss(data: WarehouseModel) {
        self.successDismissCallBack?(data)
        self.coordinator.selfPopViewController()
    }
}


enum NewWarehouseViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String, subTitle: String)
}
