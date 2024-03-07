//
//  BuyingChartsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.01.2024.
//

import UIKit

protocol IBuyingChartsCoordinator: AnyObject {

}

final class BuyingChartsCoordinator: NavigationCoordinator, IBuyingChartsCoordinator {

    private var coordinatorData: BuyingChartsPassData { return castPassData(BuyingChartsPassData.self) }

    override func start() {
        let controller = BuyingChartsBuilder.generate(with: coordinatorData,
                                                      coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}
