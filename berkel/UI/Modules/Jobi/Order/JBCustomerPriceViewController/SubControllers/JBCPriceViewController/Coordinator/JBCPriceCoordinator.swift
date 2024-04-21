//
//  JBCPriceCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IJBCPriceCoordinator: AnyObject {
    
    func presentNewJBCPriceCiewController(passData: NewJBCPricePassData,
                                            outputDelegate: NewJBCPriceViewControllerOutputDelegate)
}

final class JBCPriceCoordinator: NavigationCoordinator , IJBCPriceCoordinator {

    private var coordinatorData: JBCPricePassData { return castPassData(JBCPricePassData.self) }
    
    private weak var outputDelegate: JBCPriceViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: JBCPriceViewControllerOutputDelegate) -> JBCPriceCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

     override func start() {
        guard let outputDelegate = outputDelegate else { return }
         
        let controller = JBCPriceBuilder.generate(with: coordinatorData, 
                                                                   coordinator: self,
                                                                   outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
     }
    
    func presentNewJBCPriceCiewController(passData: NewJBCPricePassData,
                                        outputDelegate: NewJBCPriceViewControllerOutputDelegate) {
        let controller = NewJBCPriceCoordinator.getInstance(presenterViewController: self.navigationController.lastViewController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: controller)
    }
}
