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
         coordinator: IMyStockListCoordinator,
         uiModel: IMyStockListUIModel)
    
    // Service
    func saveNewStockCategory(name: String)
    
    // Coordinate
    func pushNewStockViewController()
}

final class MyStockListViewModel: BaseViewModel, IMyStockListViewModel {

    // MARK: Definitions
    private let repository: IMyStockListRepository
    private let coordinator: IMyStockListCoordinator
    private var uiModel: IMyStockListUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<MyStockListViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IMyStockListRepository,
                  coordinator: IMyStockListCoordinator,
                  uiModel: IMyStockListUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension MyStockListViewModel {

    func saveNewStockCategory(name: String) {
        
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
