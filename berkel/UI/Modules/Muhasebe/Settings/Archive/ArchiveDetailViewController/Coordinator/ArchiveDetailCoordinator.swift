//
//  ArchiveDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

protocol IArchiveDetailCoordinator: AnyObject {

    func dismiss()
}

final class ArchiveDetailCoordinator: PresentationCoordinator, IArchiveDetailCoordinator {

    private var coordinatorData: ArchiveDetailPassData { return castPassData(ArchiveDetailPassData.self) }

    override func start() {
        let controller = ArchiveDetailBuilder.generate(with: coordinatorData, coordinator: self)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss() {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: nil)
    }
}


extension ArchiveDetailCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> ArchiveDetailCoordinator {
        return ArchiveDetailCoordinator(presenterViewController: presenterViewController)
    }
}

