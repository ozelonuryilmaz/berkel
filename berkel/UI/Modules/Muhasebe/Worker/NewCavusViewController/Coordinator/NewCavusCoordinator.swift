//
//  NewCavusCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

protocol INewCavusCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class NewCavusCoordinator: PresentationCoordinator, INewCavusCoordinator {

    private var coordinatorData: NewCavusPassData { return castPassData(NewCavusPassData.self) }

    private weak var outputDelegate: NewCavusViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewCavusViewControllerOutputDelegate) -> NewCavusCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewCavusBuilder.generate(with: coordinatorData,
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

extension NewCavusCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewCavusCoordinator {
        return NewCavusCoordinator(presenterViewController: presenterViewController)
    }
}
