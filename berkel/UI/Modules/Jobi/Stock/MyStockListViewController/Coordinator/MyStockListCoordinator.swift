//
//  MyStockListCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol IMyStockListCoordinator: AnyObject {

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
}
