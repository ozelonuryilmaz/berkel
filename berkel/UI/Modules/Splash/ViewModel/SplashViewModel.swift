//
//  SplashViewModel.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

protocol ISplashViewModel: AnyObject {

    var viewState: ScreenStateSubject<SplashViewState> { get }

    init(repository: ISplashRepository,
         coordinator: ISplashCoordinator,
         uiModel: ISplashUIModel)

    func startFlowMainAfterLogin()
    func presentModuleSelectionViewController()
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
                self.decideToScreen()
            } else {
                self.presentLoginViewController(authDismissCallBack: { [weak self] _isLoggedIn in
                    guard let self = self else { return }
                    if _isLoggedIn {
                        self.decideToScreen()
                    }
                })
            }
        })
    }
}

// MARK: Props
internal extension SplashViewModel {
    
    func decideToScreen() {
        if self.uiModel.isHaveAnySeason {
            self.viewStateStartFlowMain()
        } else {
            // Eğer sezon hiç seçilmemişse sezon seçildikten sonra FlowMain akışına geçilir.
            self.presentSeasonsViewController(seasonDismissCallback: { [unowned self] isSelected in
                if isSelected {
                    self.viewStateStartFlowMain()
                } else {
                    self.decideToScreen()
                }
            })
        }
    }
}

// MARK: States
internal extension SplashViewModel {

    // MARK: View State
    func viewStateStartFlowMain() {
        viewState.value = .startFlowMain
    }

}

// MARK: Coordinate
internal extension SplashViewModel {

    func presentLoginViewController(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) {
        self.coordinator.presentLoginViewController(authDismissCallBack: authDismissCallBack)
    }

    func presentSeasonsViewController(seasonDismissCallback: ((_ isSelected: Bool) -> Void)?) {
        self.coordinator.presentSeasonsViewController(seasonDismissCallback: seasonDismissCallback)
    }
    
    func presentModuleSelectionViewController() {
        self.coordinator.presentModuleSelectionViewController()
    }
}

enum SplashViewState {
    case startFlowMain
}
