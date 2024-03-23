//
//  StockDetailInformationCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IStockDetailInformationCoordinator: AnyObject {

}

final class StockDetailInformationCoordinator: NavigationCoordinator, IStockDetailInformationCoordinator {

    private var coordinatorData: StockDetailInformationPassData { return castPassData(StockDetailInformationPassData.self) }

    override func start() {
        let controller = StockDetailInformationBuilder.generate(with: coordinatorData,
                                                                coordinator: self)
        navigationController.pushViewController(controller, animated: true)

    }
}
