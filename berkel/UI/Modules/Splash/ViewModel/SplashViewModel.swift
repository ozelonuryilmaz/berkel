//
//  SplashViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import Foundation
import Combine

protocol ISplashViewModel: AnyObject {

    var viewState: ScreenStateSubject<SplashViewState> { get }

    init(repository: ISplashRepository,
         coordinator: ISplashCoordinator,
         uiModel: ISplashUIModel)

    func getUsersForScreens()
    func presentModuleSelectionViewController()
}

final class SplashViewModel: BaseViewModel, ISplashViewModel {

    // MARK: Definitions
    private let repository: ISplashRepository
    private let coordinator: ISplashCoordinator
    private var uiModel: ISplashUIModel

    var viewState = ScreenStateSubject<SplashViewState>(nil)
    var errorState = ErrorStateSubject(nil)

    let userResponse = CurrentValueSubject<[UserModel]?, Never>(nil)

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

    func getUsersForScreens() {
        handleResourceFirestore(
            request: self.repository.getUsers(),
            response: self.userResponse,
            errorState: self.errorState,
            callbackLoading: { [weak self] isProgress in
                guard let self = self else { return }
                self.viewStateShowNativeProgress(isProgress: isProgress)
            },
            callbackSuccess: { [weak self] in
                guard let self = self else { return }
                self.uiModel.setUsers(users: self.userResponse.value ?? [])
            },
            callbackComplete: { [weak self] in
                guard let self = self else { return }
                DispatchQueue.delay(25) {[weak self] in
                    guard let self = self else { return }
                    self.startFlowAfterLogin()
                }
            })
    }

}

// MARK: Props
private extension SplashViewModel {

    // Login olduktan sonra sayfa açılmasına karar verilir
    func startFlowAfterLogin() {
        self.uiModel.isUserAlreadyLogin(completion: { [weak self] isLoggedIn in
            guard let self = self else { return }

            if isLoggedIn {
                self.decideToScreen()
            } else {
                self.presentLoginViewController(authDismissCallBack: { [weak self] _isLoggedIn in
                    guard let self = self else { return }
                    if _isLoggedIn {
                        self.getUsersForScreens()
                    } else {
                        self.decideToScreen()
                    }
                })
            }
        })
    }

    // login olduktan sonra season seçili değilse sezon seçiminden sonra sayfa açılır
    func decideToScreen() {
        if self.uiModel.isHaveAnySeason {
            self.startScreen()
        } else {
            // Eğer sezon hiç seçilmemişse sezon seçildikten sonra FlowMain akışına geçilir.
            self.presentSeasonsViewController(seasonDismissCallback: { [unowned self] isSelected in
                if !isSelected.isEmpty {
                    self.startScreen()
                } else {
                    self.decideToScreen()
                }
            })
        }
    }
    
    func startScreen() {
        self.uiModel.decideToScreen(
            accounting: {
                viewStateStartFlowAccounting()
            }, jobi: {
                viewStateStartFlowJobi()
            }, moduleSelection: {
                viewStateStartModuleSelection()
            }, restart: {
                viewStateRestartApp()
            }
        )
    }
}

// MARK: States
internal extension SplashViewModel {

    // MARK: View State
    func viewStateShowNativeProgress(isProgress: Bool) {
        viewState.value = .showNativeProgress(isProgress: isProgress)
    }

    func viewStateStartFlowAccounting() {
        viewState.value = .startFlowAccounting
    }
    
    func viewStateStartFlowJobi() {
        viewState.value = .startFlowJobi
    }

    func viewStateStartModuleSelection() {
        viewState.value = .startModuleSelection
    }
    
    func viewStateRestartApp() {
        viewState.value = .restartApp
    }
}

// MARK: Coordinate
internal extension SplashViewModel {

    func presentLoginViewController(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) {
        self.coordinator.presentLoginViewController(authDismissCallBack: authDismissCallBack)
    }

    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: String) -> Void)?) {
        self.coordinator.presentSeasonsViewController(seasonDismissCallback: seasonDismissCallback)
    }

    func presentModuleSelectionViewController() {
        self.coordinator.presentModuleSelectionViewController()
    }
}

enum SplashViewState {
    case showNativeProgress(isProgress: Bool)
    case startFlowAccounting
    case startFlowJobi
    case startModuleSelection
    case restartApp
}
