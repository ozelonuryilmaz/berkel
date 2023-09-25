//
//  SeasonsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//  Copyright (c) 2023 Emlakjet IOS Development Team. All rights reserved.[EC-2021]
//

import UIKit

protocol ISeasonsCoordinator: AnyObject {

}

final class SeasonsCoordinator: PresentationCoordinator, ISeasonsCoordinator {

    private var coordinatorData: SeasonsPassData { return castPassData(SeasonsPassData.self) }

    private var seasonDismissCallback: ((_ isSelected: Bool) -> Void)? = nil

    private weak var navController: MainNavigationController? = nil

    @discardableResult
    func with(seasonDismissCallback: ((_ isSelected: Bool) -> Void)?) -> SeasonsCoordinator {
        self.seasonDismissCallback = seasonDismissCallback
        return self
    }

    override func start() {
        let controller = SeasonsBuilder.generate(with: coordinatorData,
                                                 coordinator: self,
                                                 seasonDismissCallback: self.seasonDismissCallback)
        navController = MainNavigationController() // memory leak için weak tanımlandı
        navController!.modalPresentationStyle = .fullScreen
        navController!.setRootViewController(viewController: controller)
        startPresent(targetVC: navController!)
    }
}
