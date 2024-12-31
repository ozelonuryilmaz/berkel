//
//  SeasonsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import UIKit

protocol ISeasonsCoordinator: AnyObject {

}

final class SeasonsCoordinator: PresentationCoordinator, ISeasonsCoordinator {

    private var coordinatorData: SeasonsPassData { return castPassData(SeasonsPassData.self) }

    private var seasonDismissCallback: ((_ isSelected: String) -> Void)? = nil

    @discardableResult
    func with(seasonDismissCallback: ((_ isSelected: String) -> Void)?) -> SeasonsCoordinator {
        self.seasonDismissCallback = seasonDismissCallback
        return self
    }

    override func start() {
        let controller = SeasonsBuilder.generate(with: coordinatorData,
                                                 coordinator: self,
                                                 seasonDismissCallback: self.seasonDismissCallback)
        let navController = MainNavigationController()
        navController.modalPresentationStyle = .fullScreen
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }
}
