//
//  StockCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IStockCoordinator: AnyObject {

}

final class StockCoordinator: NavigationCoordinator, IStockCoordinator {

    private var coordinatorData: StockPassData { return castPassData(StockPassData.self) }

    override func start() {
        let controller = StockBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

}

