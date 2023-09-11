//
//  SplashViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

protocol ISplashViewModel: AnyObject {
    
    var viewState: ScreenStateSubject<SplashViewState> { get }

    init(repository: ISplashRepository,
         coordinator: ISplashCoordinator,
         uiModel: ISplashUIModel)
    
    func startFlowMainAfterLogin()
}

final class SplashViewModel: BaseViewModel, ISplashViewModel {

    // MARK: Definitions
    private let repository: ISplashRepository
    private let coordinator: ISplashCoordinator
    private var uiModel: ISplashUIModel
    
    var viewState = ScreenStateSubject<SplashViewState>(nil)

    // MARK: Initiliazer
    required init(repository: ISplashRepository,
                  coordinator: ISplashCoordinator,
                  uiModel: ISplashUIModel) {
        self.repository = repository
        self.coordinator = coordinator
        self.uiModel = uiModel
    }

    
    func startFlowMainAfterLogin() {
        self.uiModel.isUserAlreadyLogin(completion: { [weak self] isLoggedIn in
            guard let self = self else { return }
            
            if isLoggedIn {
                self.viewStateStartFlowMain()
            } else {
                self.presentLoginViewController(didDismissCallback: {
                    self.startFlowMainAfterLogin()
                })
            }
        })
    }
}


// MARK: Service
internal extension SplashViewModel {

}

// MARK: States
internal extension SplashViewModel {

    // MARK: View State
    func viewStateStartFlowMain() {
        viewState.value = .startFlowMain
    }

    // MARK: Action State

}

// MARK: Coordinate
internal extension SplashViewModel {

    func presentLoginViewController(didDismissCallback: DefaultDismissCallback?) {
        self.coordinator.presentLoginViewController(didDismissCallback: didDismissCallback)
    }
}


enum SplashViewState {
    case startFlowMain
}

enum SplashActionState {

}


