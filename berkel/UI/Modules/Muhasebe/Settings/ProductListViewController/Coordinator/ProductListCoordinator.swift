//
//  ProductListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import UIKit

protocol IProductListCoordinator: AnyObject {

    func dismiss(completion: (() -> Void)?)
}

final class ProductListCoordinator: PresentationCoordinator, IProductListCoordinator {

    private var coordinatorData: ProductListPassData { return castPassData(ProductListPassData.self) }

    private weak var outputDelegate: ProductListViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: ProductListViewControllerOutputDelegate) -> ProductListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = ProductListBuilder.generate(with: coordinatorData,
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

extension ProductListCoordinator {

    static func getInstance(presenterViewController: UIViewController?) -> ProductListCoordinator {
        return ProductListCoordinator(presenterViewController: presenterViewController)
    }
}
