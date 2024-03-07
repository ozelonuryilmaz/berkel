//
//  JobiListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IJobiListCoordinator: AnyObject {

}

final class JobiListCoordinator: NavigationCoordinator, IJobiListCoordinator {

    private var coordinatorData: JobiListPassData { return castPassData(JobiListPassData.self) }

    //private unowned var navController: MainNavigationController // Presenter

    override func start() {
        let controller = JobiListBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }


    /*func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }*/
}
