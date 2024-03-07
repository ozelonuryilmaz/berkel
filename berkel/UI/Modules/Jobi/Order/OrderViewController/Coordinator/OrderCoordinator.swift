//
//  OrderCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IOrderCoordinator: AnyObject {

}

final class OrderCoordinator: NavigationCoordinator, IOrderCoordinator {

    private var coordinatorData: OrderPassData { return castPassData(OrderPassData.self) }

    override func start() {
        let controller = OrderBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }


}
