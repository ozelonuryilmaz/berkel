//
//  LoginCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol ILoginCoordinator: AnyObject {

}

final class LoginCoordinator: PresentationCoordinator, ILoginCoordinator {

    private var coordinatorData: LoginPassData { return castPassData(LoginPassData.self) }

    override func start() {
        let controller = LoginBuilder.generate(with: coordinatorData,
                                               coordinator: self,
                                               willDismissCallback: self.willDismissCallback,
                                               didDismissCallback: self.didDismissCallback)
        let authNavigationController = UINavigationController()
        authNavigationController.setRootViewController(viewController: controller)
        authNavigationController.modalPresentationStyle = .fullScreen
        startPresent(targetVC: authNavigationController)
    }

}

extension LoginCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> LoginCoordinator {
        return LoginCoordinator(presenterViewController: presenterViewController)
    }
}
