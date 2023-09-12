//
//  SettingsViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import Combine

protocol ISettingsViewModel: AnyObject {

    var errorState: ErrorStateSubject { get }

    init(repository: ISettingsRepository,
         coordinator: ISettingsCoordinator,
         uiModel: ISettingsUIModel)

    func getDocuments()
}

final class SettingsViewModel: BaseViewModel, ISettingsViewModel {

    // MARK: Definitions
    private let repository: ISettingsRepository
    private let coordinator: ISettingsCoordinator
    private var uiModel: ISettingsUIModel

    let response = CurrentValueSubject<[SettingsResponseModel]?, Never>(nil)
    var errorState = ErrorStateSubject(nil)

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

    func getDocuments() {

        handleResourceGetDataState(
            request: self.repository.getBuyingList(),
            response: self.response,
            errorState: self.errorState,
            callbackLoading: { isProgress in
                print("***isProgress: \(isProgress ? "Yükleniyor" : "Yüklendi")")
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }

                self.response.value?.forEach { item in
                    print(item.test ?? "")
                }
            }, callbackComplete: {

            }
        )

    }
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


