//
//  SettingsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol ISettingsViewModel: AnyObject {

    init(repository: ISettingsRepository,
         coordinator: ISettingsCoordinator,
         uiModel: ISettingsUIModel)
}

final class SettingsViewModel: BaseViewModel, ISettingsViewModel {

    // MARK: Definitions
    private let repository: ISettingsRepository
    private let coordinator: ISettingsCoordinator
    private var uiModel: ISettingsUIModel

    // MARK: Initiliazer
    required init(repository: ISettingsRepository,
                  coordinator: ISettingsCoordinator,
                  uiModel: ISettingsUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension SettingsViewModel {

}

// MARK: States
internal extension SettingsViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension SettingsViewModel {

}


enum SettingsViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum SettingsActionState {

}


