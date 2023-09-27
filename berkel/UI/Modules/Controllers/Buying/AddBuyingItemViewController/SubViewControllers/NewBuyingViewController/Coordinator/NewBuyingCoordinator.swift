//
//  NewBuyingCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol INewBuyingCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class NewBuyingCoordinator: PresentationCoordinator, INewBuyingCoordinator {

    private var coordinatorData: NewBuyingPassData { return castPassData(NewBuyingPassData.self) }

    private unowned var navController: MainNavigationController

    private var successDismissCallBack: ((_ data: NewBuyingModel) -> Void)? = nil

    @discardableResult
    func with(successDismissCallBack: ((_ data: NewBuyingModel) -> Void)?) -> NewBuyingCoordinator {
        self.successDismissCallBack = successDismissCallBack
        return self
    }

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = NewBuyingBuilder.generate(with: coordinatorData,
                                                   coordinator: self,
                                                   successDismissCallBack: self.successDismissCallBack)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}


extension NewBuyingCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewBuyingCoordinator {
        return NewBuyingCoordinator(presenterViewController: presenterViewController,
                                    navController: MainNavigationController())
    }
}
