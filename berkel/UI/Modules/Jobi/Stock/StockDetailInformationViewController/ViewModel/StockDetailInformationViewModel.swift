//
//  StockDetailInformationViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Combine

protocol IStockDetailInformationViewModel: AnyObject {

    var viewState: ScreenStateSubject<StockDetailInformationViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IStockDetailInformationRepository,
         coordinator: IStockDetailInformationCoordinator,
         uiModel: IStockDetailInformationUIModel)
}

final class StockDetailInformationViewModel: BaseViewModel, IStockDetailInformationViewModel {

    // MARK: Definitions
    private let repository: IStockDetailInformationRepository
    private let coordinator: IStockDetailInformationCoordinator
    private var uiModel: IStockDetailInformationUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<StockDetailInformationViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IStockDetailInformationRepository,
                  coordinator: IStockDetailInformationCoordinator,
                  uiModel: IStockDetailInformationUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension StockDetailInformationViewModel {

}

// MARK: States
internal extension StockDetailInformationViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension StockDetailInformationViewModel {

}


enum StockDetailInformationViewState {
    case showNativeProgress(isProgress: Bool)
}
