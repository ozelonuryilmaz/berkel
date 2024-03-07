//
//  StockViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Combine

protocol IStockViewModel: AnyObject {

    var viewState: ScreenStateSubject<StockViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IStockRepository,
         coordinator: IStockCoordinator,
         uiModel: IStockUIModel)
}

final class StockViewModel: BaseViewModel, IStockViewModel {

    // MARK: Definitions
    private let repository: IStockRepository
    private let coordinator: IStockCoordinator
    private var uiModel: IStockUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<StockViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IStockRepository,
                  coordinator: IStockCoordinator,
                  uiModel: IStockUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension StockViewModel {

}

// MARK: States
internal extension StockViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension StockViewModel {

}


enum StockViewState {
    case showNativeProgress(isProgress: Bool)
}
