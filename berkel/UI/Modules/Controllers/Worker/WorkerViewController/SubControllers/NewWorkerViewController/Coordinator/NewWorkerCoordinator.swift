//
//  NewWorkerCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

protocol INewWorkerCoordinator: AnyObject {
    func dismiss(completion: (() -> Void)?)
}

final class NewWorkerCoordinator: PresentationCoordinator, INewWorkerCoordinator {

    private var coordinatorData: NewWorkerPassData { return castPassData(NewWorkerPassData.self) }

    private unowned var navController: MainNavigationController
    
    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = NewWorkerBuilder.generate(with: coordinatorData,
                                                   coordinator: self)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension NewWorkerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewWorkerCoordinator {
        return NewWorkerCoordinator(presenterViewController: presenterViewController,
                                    navController: MainNavigationController())
    }
}
