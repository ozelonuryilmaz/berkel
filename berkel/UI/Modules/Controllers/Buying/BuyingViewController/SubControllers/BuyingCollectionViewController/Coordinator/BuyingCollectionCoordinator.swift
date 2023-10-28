//
//  BuyingCollectionCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.10.2023.
//

import UIKit

protocol IBuyingCollectionCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class BuyingCollectionCoordinator: PresentationCoordinator, IBuyingCollectionCoordinator {

    private var coordinatorData: BuyingCollectionPassData { return castPassData(BuyingCollectionPassData.self) }

    private unowned var navController: MainNavigationController

    private var successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)? = nil

    @discardableResult
    func with(successDismissCallBack: ((_ data: BuyingCollectionModel) -> Void)?) -> BuyingCollectionCoordinator {
        self.successDismissCallBack = successDismissCallBack
        return self
    }

    init(presenterViewController: UIViewController?, navController: MainNavigationController) {
        self.navController = navController
        super.init(presenterViewController: presenterViewController)
    }

    override func start() {
        let controller = BuyingCollectionBuilder.generate(with: coordinatorData,
                                                          coordinator: self,
                                                          successDismissCallBack: self.successDismissCallBack)
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        navController.dismiss(animated: true, completion: completion)
    }
}



extension BuyingCollectionCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> BuyingCollectionCoordinator {
        return BuyingCollectionCoordinator(presenterViewController: presenterViewController,
                                           navController: MainNavigationController())
    }
}
