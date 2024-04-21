//
//  NewJBCPriceCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol INewJBCPriceCoordinator: AnyObject {
    
    func dismiss(completion: (() -> Void)?)
}

final class NewJBCPriceCoordinator: PresentationCoordinator, INewJBCPriceCoordinator {

    private var coordinatorData: NewJBCPricePassData { return castPassData(NewJBCPricePassData.self) }
    
    private weak var outputDelegate: NewJBCPriceViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewJBCPriceViewControllerOutputDelegate) -> NewJBCPriceCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

     override func start() {
        guard let outputDelegate = outputDelegate else { return }
         
        let controller = NewJBCPriceBuilder.generate(with: coordinatorData, 
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
 extension NewJBCPriceCoordinator {

     static func getInstance(presenterViewController: UIViewController?) -> NewJBCPriceCoordinator {
         return NewJBCPriceCoordinator(presenterViewController: presenterViewController)
     }
 }
