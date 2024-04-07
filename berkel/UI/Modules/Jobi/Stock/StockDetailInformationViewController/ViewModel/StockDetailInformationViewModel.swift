//
//  StockDetailInformationViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Combine

protocol IStockDetailInformationViewModel: UpdateStockViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<StockDetailInformationViewState> { get }
    var errorState: ErrorStateSubject { get }

    var navigationTitle: String { get }
    var navigationSubTitle: String { get }

    init(repository: IStockDetailInformationRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IStockDetailInformationCoordinator,
         uiModel: IStockDetailInformationUIModel)

    // Coordinate
    func presentUpdateStockViewController(type: UpdateStockType)
}

final class StockDetailInformationViewModel: BaseViewModel, IStockDetailInformationViewModel {

    // MARK: Definitions
    private let repository: IStockDetailInformationRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IStockDetailInformationCoordinator
    private var uiModel: IStockDetailInformationUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<StockDetailInformationViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IStockDetailInformationRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IStockDetailInformationCoordinator,
                  uiModel: IStockDetailInformationUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var navigationTitle: String {
        return uiModel.navigationTitle
    }

    var navigationSubTitle: String {
        return uiModel.navigationSubTitle
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

    func presentUpdateStockViewController(type: UpdateStockType) {
        self.coordinator.presentUpdateStockViewController(passData: uiModel.getUpdateStockPassData(type: type),
                                                          outputDelegate: self)
    }
}

// MARK: UpdateStockViewControllerOutputDelegate
internal extension StockDetailInformationViewModel {
    
}

enum StockDetailInformationViewState {
    case showNativeProgress(isProgress: Bool)
}
