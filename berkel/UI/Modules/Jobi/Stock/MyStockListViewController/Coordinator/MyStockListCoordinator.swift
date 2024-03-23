//
//  MyStockListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IMyStockListCoordinator: AnyObject {

    func pushNewStockViewController(passData: NewStockPassData,
                                    outputDelegate: NewStockViewControllerOutputDelegate)
}

final class MyStockListCoordinator: NavigationCoordinator, IMyStockListCoordinator {

    private var coordinatorData: MyStockListPassData { return castPassData(MyStockListPassData.self) }

    private weak var outputDelegate: MyStockListViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: MyStockListViewControllerOutputDelegate) -> MyStockListCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = MyStockListBuilder.generate(with: coordinatorData,
                                                     coordinator: self,
                                                     outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func pushNewStockViewController(passData: NewStockPassData,
                                    outputDelegate: NewStockViewControllerOutputDelegate) {
        let coordinator = NewStockCoordinator(navigationController: self.navigationController)
            .with(outputDelegate: outputDelegate)
            .with(passData: passData)
        coordinate(to: coordinator)
    }
}
