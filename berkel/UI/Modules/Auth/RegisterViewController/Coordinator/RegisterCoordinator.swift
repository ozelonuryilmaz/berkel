//
//  RegisterCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IRegisterCoordinator: AnyObject {

    func popToRootViewController(animated: Bool)
}

final class RegisterCoordinator: NavigationCoordinator, IRegisterCoordinator {

    private var coordinatorData: RegisterPassData { return castPassData(RegisterPassData.self) }

    private var authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)? = nil

    @discardableResult
    func with(authDismissCallBack: ((_ isLoggedIn: Bool) -> Void)?) -> RegisterCoordinator {
        self.authDismissCallBack = authDismissCallBack
        return self
    }

    override func start() {
        let controller = RegisterBuilder.generate(with: coordinatorData,
                                                  coordinator: self,
                                                  authDismissCallBack: self.authDismissCallBack)

        navigationController.pushViewController(controller, animated: true)
    }

    func popToRootViewController(animated: Bool) {
        self.navigationController.popToRootViewController(animated: animated)
    }
}
