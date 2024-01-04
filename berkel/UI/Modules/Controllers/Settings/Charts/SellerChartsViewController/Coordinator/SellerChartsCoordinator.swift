//
//  SellerChartsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.12.2023.
//

import UIKit

protocol ISellerChartsCoordinator: AnyObject {

}

final class SellerChartsCoordinator: NavigationCoordinator, ISellerChartsCoordinator {

    private var coordinatorData: SellerChartsPassData { return castPassData(SellerChartsPassData.self) }

    override func start() {
        let controller = SellerChartsBuilder.generate(with: coordinatorData,
                                                      coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}
