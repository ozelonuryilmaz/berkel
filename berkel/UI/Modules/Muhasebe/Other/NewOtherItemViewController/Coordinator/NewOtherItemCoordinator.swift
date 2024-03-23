//
//  NewOtherItemCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.01.2024.
//

import UIKit

protocol INewOtherItemCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class NewOtherItemCoordinator: PresentationCoordinator, INewOtherItemCoordinator {

    private var coordinatorData: NewOtherItemPassData { return castPassData(NewOtherItemPassData.self) }

    private weak var outputDelegate: NewOtherItemViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewOtherItemViewControllerOutputDelegate) -> NewOtherItemCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewOtherItemBuilder.generate(with: coordinatorData,
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
extension NewOtherItemCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewOtherItemCoordinator {
        return NewOtherItemCoordinator(presenterViewController: presenterViewController)
    }
}
