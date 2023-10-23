//
//  NewSellerImageCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol INewSellerImageCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class NewSellerImageCoordinator: PresentationCoordinator, INewSellerImageCoordinator {

    private var coordinatorData: NewSellerImagePassData { return castPassData(NewSellerImagePassData.self) }

    private unowned var navController: MainNavigationController

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = NewSellerImageBuilder.generate(with: coordinatorData,
                                                        coordinator: self)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

extension NewSellerImageCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewSellerImageCoordinator {
        return NewSellerImageCoordinator(presenterViewController: presenterViewController,
                                         navController: MainNavigationController())
    }
}

