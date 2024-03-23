//
//  MyStockListViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import Combine

protocol IMyStockListViewModel: NewStockViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<MyStockListViewState> { get }
    var errorState: ErrorStateSubject { get }

    init(repository: IMyStockListRepository,
         jobiStockRepository: IJobiStockRepository,
         coordinator: IMyStockListCoordinator,
         uiModel: IMyStockListUIModel)
    
    // Service
    func saveStock(name: String)
    
    // Coordinate
    func pushNewStockViewController()
}

final class MyStockListViewModel: BaseViewModel, IMyStockListViewModel {

    // MARK: Definitions
    private let repository: IMyStockListRepository
    private let jobiStockRepository: IJobiStockRepository
    private let coordinator: IMyStockListCoordinator
    private var uiModel: IMyStockListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<MyStockListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    let responseStock = CurrentValueSubject<StockModel?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IMyStockListRepository,
                  jobiStockRepository: IJobiStockRepository,
                  coordinator: IMyStockListCoordinator,
                  uiModel: IMyStockListUIModel) {
        self.repository = repository
        self.jobiStockRepository = jobiStockRepository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension MyStockListViewModel {

    func saveStock(name: String) {
        handleResourceFirestore(
            request: self.jobiStockRepository.saveStock(season: self.uiModel.season,
                                                        data: self.uiModel.getStockModel(name: name)),
            response: self.responseStock,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            }, callbackSuccess: { [weak self] in
                guard let self = self,
                    let response = self.responseStock.value else { return }
                
            })
    }
}

// MARK: States
internal extension MyStockListViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension MyStockListViewModel {

    func pushNewStockViewController() {
        self.coordinator.pushNewStockViewController(passData: NewStockPassData(),
                                                    outputDelegate: self)
    }
}

// MARK: NewStockViewControllerOutputDelegate
internal extension MyStockListViewModel {

    func newStockData(_ data: StockModel) {
        
    }
}

enum MyStockListViewState {
    case showNativeProgress(isProgress: Bool)
}
