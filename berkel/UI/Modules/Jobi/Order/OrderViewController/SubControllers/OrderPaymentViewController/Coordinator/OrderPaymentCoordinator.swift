//
//  OrderPaymentCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.04.2024.
//  Copyright (c) 2024 Berkel IOS Development Team. All rights reserved.[OY-2024]
//

import UIKit

protocol IOrderPaymentCoordinator: AnyObject {
    func dismiss(completion: (() -> Void)?)
}

final class OrderPaymentCoordinator: PresentationCoordinator, IOrderPaymentCoordinator {

    private var coordinatorData: OrderPaymentPassData { return castPassData(OrderPaymentPassData.self) }
    
    private weak var outputDelegate: OrderPaymentViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: OrderPaymentViewControllerOutputDelegate) -> OrderPaymentCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

     override func start() {
        guard let outputDelegate = outputDelegate else { return }
         
        let controller = OrderPaymentBuilder.generate(with: coordinatorData, 
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
 extension OrderPaymentCoordinator {

     static func getInstance(presenterViewController: UIViewController?) -> OrderPaymentCoordinator {
         return OrderPaymentCoordinator(presenterViewController: presenterViewController)
     }
 }
