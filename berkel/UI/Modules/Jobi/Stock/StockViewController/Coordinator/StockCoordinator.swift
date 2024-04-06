//
//  StockCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

protocol IStockCoordinator: AnyObject {

    func pushMyStockListViewController(passData: MyStockListPassData,
                                       outputDelegate: MyStockListViewControllerOutputDelegate)
    
    func pushStockDetailInfoViewController(passData: StockDetailInformationPassData)
}

final class StockCoordinator: NavigationCoordinator, IStockCoordinator {

    private var coordinatorData: StockPassData { return castPassData(StockPassData.self) }

    override func start() {
        let controller = StockBuilder.generate(coordinator: self)
        navigationController.viewControllers = [controller]
    }

    func pushMyStockListViewController(passData: MyStockListPassData,
                                       outputDelegate: MyStockListViewControllerOutputDelegate) {
        let coordinator = MyStockListCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
    
    func pushStockDetailInfoViewController(passData: StockDetailInformationPassData) {
        let coordinator = StockDetailInformationCoordinator(navigationController: self.navigationController)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
}

