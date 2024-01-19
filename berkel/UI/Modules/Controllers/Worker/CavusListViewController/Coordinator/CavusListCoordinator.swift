//
//  CavusListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 31.10.2023.
//

import UIKit

protocol ICavusListCoordinator: AnyObject {

    func presentNewCavusViewController(passData: NewCavusPassData,
                                       outputDelegate: NewCavusViewControllerOutputDelegate)
    
    func presentNewWorkerViewController(passData: NewWorkerPassData,
                                        outputDelegate: NewWorkerViewControllerOutputDelegate)
    
    func pushArchiveListViewController(passData: ArchiveListPassData)
    func popToRootViewController(animated: Bool)
}

final class CavusListCoordinator: NavigationCoordinator, ICavusListCoordinator {

    private var coordinatorData: CavusListPassData { return castPassData(CavusListPassData.self) }
    
    private weak var outputDelegate: NewWorkerViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewWorkerViewControllerOutputDelegate) -> CavusListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }
    
    override func start() {
        guard let outputDelegate = outputDelegate else { return }
        
        let controller = CavusListBuilder.generate(with: coordinatorData,
                                                   coordinator: self,
                                                   outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentNewCavusViewController(passData: NewCavusPassData, outputDelegate: NewCavusViewControllerOutputDelegate) {
        let controller = NewCavusCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }
    
    func presentNewWorkerViewController(passData: NewWorkerPassData,
                                        outputDelegate: NewWorkerViewControllerOutputDelegate) {
        let controller = NewWorkerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }
    
    func pushArchiveListViewController(passData: ArchiveListPassData) {
        let coordinator = ArchiveListCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
    
    func popToRootViewController(animated: Bool) {
        self.navigationController.popToRootViewController(animated: animated)
    }
}
