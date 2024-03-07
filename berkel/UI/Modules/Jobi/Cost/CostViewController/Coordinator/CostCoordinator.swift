//
//  CostCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol ICostCoordinator: AnyObject {

}

final class CostCoordinator: NavigationCoordinator, ICostCoordinator {

    private var coordinatorData: CostPassData { return castPassData(CostPassData.self) }

    //private unowned var navController: MainNavigationController // Presenter

    override func start() {
        let controller = CostBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }


    /*func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }*/
}
