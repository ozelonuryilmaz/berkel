//
//  StockDetailViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Combine

protocol IStockDetailViewModel: AnyObject {

    var viewState: ScreenStateSubject<StockDetailViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IStockDetailRepository,
         coordinator: IStockDetailCoordinator,
         uiModel: IStockDetailUIModel)
}

final class StockDetailViewModel: BaseViewModel, IStockDetailViewModel {

    // MARK: Definitions
    private let repository: IStockDetailRepository
    private let coordinator: IStockDetailCoordinator
    private var uiModel: IStockDetailUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<StockDetailViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IStockDetailRepository,
                  coordinator: IStockDetailCoordinator,
                  uiModel: IStockDetailUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension StockDetailViewModel {

}

// MARK: States
internal extension StockDetailViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension StockDetailViewModel {

}


enum StockDetailViewState {
    case showNativeProgress(isProgress: Bool)
}
