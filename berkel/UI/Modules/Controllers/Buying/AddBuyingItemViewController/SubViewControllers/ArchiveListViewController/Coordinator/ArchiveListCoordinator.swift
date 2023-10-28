//
//  ArchiveListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

protocol IArchiveListCoordinator: AnyObject {

    func presentArchiveDetailViewController(passData: ArchiveDetailPassData)
}

final class ArchiveListCoordinator: NavigationCoordinator, IArchiveListCoordinator {

    private var coordinatorData: ArchiveListPassData { return castPassData(ArchiveListPassData.self) }

    override func start() {
        let controller = ArchiveListBuilder.generate(with: coordinatorData, coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentArchiveDetailViewController(passData: ArchiveDetailPassData) {
        let controller = ArchiveDetailCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
