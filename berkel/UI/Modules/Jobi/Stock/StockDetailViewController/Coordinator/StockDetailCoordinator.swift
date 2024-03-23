//
//  StockDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IStockDetailCoordinator: AnyObject {

}

final class StockDetailCoordinator: NavigationCoordinator, IStockDetailCoordinator {

    private var coordinatorData: StockDetailPassData { return castPassData(StockDetailPassData.self) }

    override func start() {
        let controller = StockDetailBuilder.generate(with: coordinatorData,
                                                     coordinator: self)
        navigationController.pushViewController(controller, animated: true)

    }
}
