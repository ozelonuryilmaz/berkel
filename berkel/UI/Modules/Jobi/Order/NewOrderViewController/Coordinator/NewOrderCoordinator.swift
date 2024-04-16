//
//  NewOrderCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol INewOrderCoordinator: AnyObject {
    func dismiss(completion: (() -> Void)?)
}

final class NewOrderCoordinator: PresentationCoordinator, INewOrderCoordinator {

    private var coordinatorData: NewOrderPassData { return castPassData(NewOrderPassData.self) }
    
    private weak var outputDelegate: NewOrderViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewOrderViewControllerOutputDelegate) -> NewOrderCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

     override func start() {
        guard let outputDelegate = outputDelegate else { return }
         
        let controller = NewOrderBuilder.generate(with: coordinatorData, 
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
 extension NewOrderCoordinator {

     static func getInstance(presenterViewController: UIViewController?) -> NewOrderCoordinator {
         return NewOrderCoordinator(presenterViewController: presenterViewController)
     }
 }
