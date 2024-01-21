//
//  CustomerListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.11.2023.
//

import UIKit

protocol ICustomerListCoordinator: AnyObject {

    func presentNewCustomerViewController(passData: NewCustomerPassData,
                                          outputDelegate: NewCustomerViewControllerOutputDelegate)
    
    func presentNewSellerViewController(passData: NewSellerPassData,
                                        outputDelegate: NewSellerViewControllerOutputDelegate)
    
    func pushArchiveListViewController(passData: ArchiveListPassData)
    func popToRootViewController(animated: Bool)
}

final class CustomerListCoordinator: NavigationCoordinator, ICustomerListCoordinator {

    private var coordinatorData: CustomerListPassData { return castPassData(CustomerListPassData.self) }
    
    private weak var outputDelegate: NewSellerViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewSellerViewControllerOutputDelegate) -> CustomerListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }
        
        let controller = CustomerListBuilder.generate(with: coordinatorData,
                                                      coordinator: self,
                                                      outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func presentNewCustomerViewController(passData: NewCustomerPassData, outputDelegate: NewCustomerViewControllerOutputDelegate) {
        let controller = NewCustomerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }
    
    func presentNewSellerViewController(passData: NewSellerPassData,
                                        outputDelegate: NewSellerViewControllerOutputDelegate) {
        let controller = NewSellerCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
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
