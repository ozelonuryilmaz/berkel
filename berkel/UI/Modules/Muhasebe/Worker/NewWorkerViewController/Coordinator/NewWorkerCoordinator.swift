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

    private weak var outputDelegate: NewWorkerViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewWorkerViewControllerOutputDelegate) -> NewWorkerCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewWorkerBuilder.generate(with: coordinatorData,
                                                   coordinator: self,
                                                   outputDelegate: outputDelegate)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension NewWorkerCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewWorkerCoordinator {
        return NewWorkerCoordinator(presenterViewController: presenterViewController)
    }
}
