//
//  NewBuyingCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol INewBuyingCoordinator: AnyObject {
    
}

final class NewBuyingCoordinator: PresentationCoordinator , INewBuyingCoordinator {

    private var coordinatorData: NewBuyingPassData { return castPassData(NewBuyingPassData.self) }

    private unowned var navController: MainNavigationController

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }
    
     override func start() {
        let controller = NewBuyingBuilder.generate(with: coordinatorData,
                                                   coordinator: self)
         navController.setRootViewController(viewController: controller)
         startPresent(targetVC: navController)
     }
}


extension NewBuyingCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewBuyingCoordinator {
        return NewBuyingCoordinator(presenterViewController: presenterViewController,
                                    navController: MainNavigationController())
    }
}
