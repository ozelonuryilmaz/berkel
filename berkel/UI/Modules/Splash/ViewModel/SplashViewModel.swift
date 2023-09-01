//
//  SplashViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol ISplashViewModel: AnyObject {

    init(repository: ISplashRepository,
         coordinator: ISplashCoordinator,
         uiModel: ISplashUIModel)
}

final class SplashViewModel: BaseViewModel, ISplashViewModel {

    // MARK: Definitions
    private let repository: ISplashRepository
    private let coordinator: ISplashCoordinator
    private var uiModel: ISplashUIModel

    // MARK: Initiliazer
    required init(repository: ISplashRepository,
                  coordinator: ISplashCoordinator,
                  uiModel: ISplashUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

}


// MARK: Service
internal extension SplashViewModel {

}

// MARK: States
internal extension SplashViewModel {

    // MARK: View State

    // MARK: Action State

}

// MARK: Coordinate
internal extension SplashViewModel {

}


enum SplashViewState {
    case showLoadingProgress(isProgress: Bool)
}

enum SplashActionState {

}


