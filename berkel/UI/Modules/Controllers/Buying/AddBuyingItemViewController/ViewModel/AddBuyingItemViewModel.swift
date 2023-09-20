//
//  AddBuyingItemViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol IAddBuyingItemViewModel: AddBuyingItemDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<AddBuyingItemViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IAddBuyingItemRepository,
         coordinator: IAddBuyingItemCoordinator,
         uiModel: IAddBuyingItemUIModel)
    
    // Services
    func getBuyingItems()

    // Coordinator
    func presentAddSellerViewController()
}

final class AddBuyingItemViewModel: BaseViewModel, IAddBuyingItemViewModel {

    // MARK: Definitions
    private let repository: IAddBuyingItemRepository
    private let coordinator: IAddBuyingItemCoordinator
    private var uiModel: IAddBuyingItemUIModel

    // MARK: Private Props

    // MARK: Public Props
    var viewState = ScreenStateSubject<AddBuyingItemViewState>(nil)
    let response = CurrentValueSubject<[AddBuyingItemResponseModel]?, Never>(nil)
    var errorState = ErrorStateSubject(nil)

    // MARK: Initiliazer
    required init(repository: IAddBuyingItemRepository,
                  coordinator: IAddBuyingItemCoordinator,
                  uiModel: IAddBuyingItemUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension AddBuyingItemViewModel {

    func getBuyingItems() {

        handleResourceFirestore(
            request: self.repository.getBuyingItemList(),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { isProgress in
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setResponse(self.response.value ?? [])
                self.viewStateUpdateSnapshot()
            }
        )
    }
}

// MARK: States
internal extension AddBuyingItemViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateUpdateSnapshot() {
        viewState.value = .updateSnapshot(snapshot: self.uiModel.buildSnapshot())
    }

}

// MARK: Coordinate
internal extension AddBuyingItemViewModel {

    func presentAddSellerViewController() {
        self.coordinator.presentAddSellerViewController()
    }
}

// MARK: AddBuyingItemDataSourceFactoryOutputDelegate
extension AddBuyingItemViewModel {

    func cellTapped(uiModel: IAddBuyingItemTableViewCellUIModel) {
        print("**** \(uiModel)")
    }

    func scrollDidScroll(isAvailablePagination: Bool) {

    }
}

enum AddBuyingItemViewState {
    case showNativeProgress(isProgress: Bool)
    case updateSnapshot(snapshot: AddBuyingItemSnapshot)
}
