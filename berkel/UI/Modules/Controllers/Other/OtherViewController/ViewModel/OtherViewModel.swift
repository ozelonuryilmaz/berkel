//
//  OtherViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import Combine

protocol IOtherViewModel: NewOtherItemViewControllerOutputDelegate {

    var viewState: ScreenStateSubject<OtherViewState> { get }
    var errorState: ErrorStateSubject { get }

    var season: String { get }

    init(repository: IOtherRepository,
         coordinator: IOtherCoordinator,
         uiModel: IOtherUIModel)

    // Coordinator
    func pushOtherItemListViewController()
}

final class OtherViewModel: BaseViewModel, IOtherViewModel {

    // MARK: Definitions
    private let repository: IOtherRepository
    private let coordinator: IOtherCoordinator
    private var uiModel: IOtherUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<OtherViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IOtherRepository,
                  coordinator: IOtherCoordinator,
                  uiModel: IOtherUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var season: String {
        return uiModel.season
    }
}


// MARK: Service
internal extension OtherViewModel {

}

// MARK: States
internal extension OtherViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

}

// MARK: Coordinate
internal extension OtherViewModel {

    func pushOtherItemListViewController() {
        self.coordinator.pushOtherSellerListViewController(passData: OtherSellerListPassData(),
                                                           outputDelegate: self)
    }
}

// MARK: NewOtherItemViewControllerOutputDelegate
internal extension OtherViewModel {

    func newOtherItemData(_ data: OtherModel) {
        //self.uiModel.appendFirstItem(data: data)
        //self.viewStateBuildSnapshot()
    }
}

enum OtherViewState {
    case showNativeProgress(isProgress: Bool)
}
