//
//  WarehouseListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 17.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IWarehouseListViewModel: AnyObject {

    var viewState: ScreenStateSubject<WarehouseListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IWarehouseListRepository,
         coordinator: IWarehouseListCoordinator,
         uiModel: IWarehouseListUIModel,
         successDismissCallBack: ((_ data: WarehouseModel) -> Void)?)

    func initComponents()
    
    // ViewState
    func viewStateSetNavigationTitle()

    // Coordinate
    func pushNewWarehouseViewController()
    func dismiss()
}

final class WarehouseListViewModel: BaseViewModel, IWarehouseListViewModel {

    // MARK: Definitions
    private let repository: IWarehouseListRepository
    private let coordinator: IWarehouseListCoordinator
    private var uiModel: IWarehouseListUIModel
    var successDismissCallBack: ((_ data: WarehouseModel) -> Void)? = nil

    // MARK: Public Props
    var viewState = ScreenStateSubject<WarehouseListViewState>(nil)
    var errorState = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: IWarehouseListRepository,
                  coordinator: IWarehouseListCoordinator,
                  uiModel: IWarehouseListUIModel,
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
internal extension WarehouseListViewModel {

}

// MARK: States
internal extension WarehouseListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }
    
    func viewStateSetNavigationTitle() {
        self.viewState.value = .setNavigationTitle(title: self.uiModel.date ?? "",
                                                   subTitle: "Depo Çıkması")
    }

    // MARK: Action State

}

// MARK: Coordinate
internal extension WarehouseListViewModel {

    func dismiss() {
        self.coordinator.dismiss(completion: nil)
    }

    func successDismiss(data: WarehouseModel) {
        self.coordinator.dismiss(completion: { [weak self] in
            self?.successDismissCallBack?(data)
        })
    }

    func pushNewWarehouseViewController() {
        self.coordinator.pushNewWarehouseViewController(
            passData: NewWarehousePassData(buyingId: self.uiModel.buyingId,
                                           collectionId: self.uiModel.collectionId,
                                           date: self.uiModel.date),
            successDismissCallBack: { data in
                self.successDismiss(data: data)
            }
        )
    }
}


enum WarehouseListViewState {
    case showNativeProgress(isProgress: Bool)
    case setNavigationTitle(title: String, subTitle: String)
}

