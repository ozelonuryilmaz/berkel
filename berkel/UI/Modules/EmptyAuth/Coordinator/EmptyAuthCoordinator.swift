//
//  EmptyAuthCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 13.03.2024.
//

import UIKit

protocol IEmptyAuthCoordinator: AnyObject {

}

final class EmptyAuthCoordinator: PresentationCoordinator, IEmptyAuthCoordinator {

    private var coordinatorData: EmptyAuthPassData { return castPassData(EmptyAuthPassData.self) }

    private weak var navController: MainNavigationController? = nil

    override func start() {
        let controller = EmptyAuthBuilder.generate(with: coordinatorData,
                                                                   coordinator: self)

        navController = MainNavigationController() // memory leak için weak tanımlandı
        navController!.modalPresentationStyle = .fullScreen
        navController!.modalTransitionStyle = .crossDissolve
        navController!.setRootViewController(viewController: controller)
        startPresent(targetVC: navController!)
    }

}
