//
//  BuyingDetailCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 15.10.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol IBuyingDetailCoordinator: AnyObject {

}

final class BuyingDetailCoordinator: NavigationCoordinator, IBuyingDetailCoordinator {

    private var coordinatorData: BuyingDetailPassData { return castPassData(BuyingDetailPassData.self) }

    override func start() {
        let controller = BuyingDetailBuilder.generate(with: coordinatorData, coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}
