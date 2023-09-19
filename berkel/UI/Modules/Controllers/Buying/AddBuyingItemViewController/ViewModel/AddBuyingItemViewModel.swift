//
//  AddBuyingItemViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 14.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol IAddBuyingItemViewModel: AddBuyingItemDataSourceFactoryOutputDelegate {

    var viewState: ScreenStateSubject<AddBuyingItemViewState> { get }

    init(repository: IAddBuyingItemRepository,
         coordinator: IAddBuyingItemCoordinator,
         uiModel: IAddBuyingItemUIModel)

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

    // MARK: Action State

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

    }

    func scrollDidScroll(isAvailablePagination: Bool) {

    }
}

enum AddBuyingItemViewState {
    case showNativeProgress(isProgress: Bool)
    case updateSnapshot(snapshot: AddBuyingItemSnapshot)
}
