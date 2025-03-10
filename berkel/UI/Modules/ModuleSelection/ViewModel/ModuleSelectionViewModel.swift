//
//  ModuleSelectionViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import Combine

protocol IModuleSelectionViewModel: AnyObject {

    var viewState: ScreenStateSubject<ModuleSelectionViewState> { get }
    var errorState: ErrorStateSubject { get }
    var isAdmin: Bool { get }

    init(repository: IModuleSelectionRepository,
         coordinator: IModuleSelectionCoordinator,
         uiModel: IModuleSelectionUIModel)
    
    func viewStateSetSeasonTitle()
}

final class ModuleSelectionViewModel: BaseViewModel, IModuleSelectionViewModel {

    // MARK: Definitions
    private let repository: IModuleSelectionRepository
    private let coordinator: IModuleSelectionCoordinator
    private var uiModel: IModuleSelectionUIModel

    // MARK: Public Props
    var viewState = ScreenStateSubject<ModuleSelectionViewState>(nil)
    var errorState = ErrorStateSubject(nil)
    //let response = CurrentValueSubject<?, Never>(nil)

    // MARK: Initiliazer
    required init(repository: IModuleSelectionRepository,
                  coordinator: IModuleSelectionCoordinator,
                  uiModel: IModuleSelectionUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    var isAdmin: Bool {
        return uiModel.isAdmin
    }
}


// MARK: Service
internal extension ModuleSelectionViewModel {

}

// MARK: States
internal extension ModuleSelectionViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateSetSeasonTitle() {
        viewState.value = .setSeasonTitle(title: self.uiModel.seasonTitle)
    }
}

// MARK: Coordinate
internal extension ModuleSelectionViewModel {

}


enum ModuleSelectionViewState {
    case showNativeProgress(isProgress: Bool)
    case setSeasonTitle(title: String)
}
