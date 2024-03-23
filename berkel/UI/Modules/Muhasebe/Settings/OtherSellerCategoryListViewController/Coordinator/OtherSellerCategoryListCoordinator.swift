//
//  OtherSellerCategoryListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

protocol IOtherSellerCategoryListCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class OtherSellerCategoryListCoordinator: PresentationCoordinator, IOtherSellerCategoryListCoordinator {

    private var coordinatorData: OtherSellerCategoryListPassData { return castPassData(OtherSellerCategoryListPassData.self) }

    private weak var outputDelegate: OtherSellerCategoryListViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: OtherSellerCategoryListViewControllerOutputDelegate) -> OtherSellerCategoryListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }
        
        let controller = OtherSellerCategoryListBuilder.generate(with: coordinatorData,
                                                                 coordinator: self,
                                                                 outputDelegate: outputDelegate)
        let navController = MainNavigationController()
        navController.setRootViewController(viewController: controller)
        startPresent(targetVC: navController)
    }


    func dismiss(completion: (() -> Void)? = nil) {
        UIApplication.topViewController()?.navigationController?.dismiss(animated: true, completion: completion)
    }
}

// Presenter
extension OtherSellerCategoryListCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> OtherSellerCategoryListCoordinator {
        return OtherSellerCategoryListCoordinator(presenterViewController: presenterViewController)
    }
}
