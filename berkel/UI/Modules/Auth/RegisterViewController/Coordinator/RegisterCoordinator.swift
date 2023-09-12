//
//  RegisterCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IRegisterCoordinator: AnyObject {

    func popToRootViewController()
}

final class RegisterCoordinator: NavigationCoordinator, IRegisterCoordinator {

    private var coordinatorData: RegisterPassData { return castPassData(RegisterPassData.self) }

    override func start() {
        let controller = RegisterBuilder.generate(with: coordinatorData, coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func popToRootViewController() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
