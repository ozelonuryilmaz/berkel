//
//  OtherSellerChartsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import UIKit

protocol IOtherSellerChartsCoordinator: AnyObject {

}

final class OtherSellerChartsCoordinator: NavigationCoordinator, IOtherSellerChartsCoordinator {

    private var coordinatorData: OtherSellerChartsPassData { return castPassData(OtherSellerChartsPassData.self) }

    override func start() {
        let controller = OtherSellerChartsBuilder.generate(with: coordinatorData,
                                                                   coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}
