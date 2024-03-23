//
//  NewSellerImageCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.10.2023.
//

import UIKit

protocol INewSellerImageCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class NewSellerImageCoordinator: PresentationCoordinator, INewSellerImageCoordinator {

    private var coordinatorData: NewSellerImagePassData { return castPassData(NewSellerImagePassData.self) }

    override func start() {
        let controller = NewSellerImageBuilder.generate(with: coordinatorData,
                                                        coordinator: self)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}

extension NewSellerImageCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> NewSellerImageCoordinator {
        return NewSellerImageCoordinator(presenterViewController: presenterViewController)
    }
}

