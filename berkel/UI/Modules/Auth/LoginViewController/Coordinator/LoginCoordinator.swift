//
//  LoginCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//

import UIKit

protocol ILoginCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
    func pushRegisterViewController(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?)
}

final class LoginCoordinator: PresentationCoordinator, ILoginCoordinator {

    private var coordinatorData: LoginPassData { return castPassData(LoginPassData.self) }

    private weak var authNavigationController: MainNavigationController? = nil

    private var authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)? = nil

    @discardableResult
    func with(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) -> LoginCoordinator {
        self.authDismissCallBack = authDismissCallBack
        return self
    }

    override func start() {
        let controller = LoginBuilder.generate(with: coordinatorData,
                                               coordinator: self,
                                               willDismissCallback: self.willDismissCallback,
                                               didDismissCallback: self.didDismissCallback,
                                               authDismissCallBack: self.authDismissCallBack)
        authNavigationController = MainNavigationController() // memory leak için weak tanımlandı
        authNavigationController!.setRootViewController(viewController: controller)
        authNavigationController!.modalPresentationStyle = .fullScreen
        startPresent(targetVC: authNavigationController!)
    }

    func pushRegisterViewController(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) {
        guard let navController = authNavigationController else { return }
        let coordinator = RegisterCoordinator(navigationController: navController)
            .with(authDismissCallBack: authDismissCallBack)
            .with(passData: RegisterPassData())
        coordinate(to: coordinator)
    }

    func dismiss(completion: (() -> Void)?) {
        self.authNavigationController?.dismiss(animated: true, completion: completion)
    }
}
