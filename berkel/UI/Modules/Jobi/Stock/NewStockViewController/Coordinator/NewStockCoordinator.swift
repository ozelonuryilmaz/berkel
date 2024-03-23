//
//  NewStockCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 20.03.2024.
//

import UIKit

protocol INewStockCoordinator: AnyObject {

}

final class NewStockCoordinator: NavigationCoordinator, INewStockCoordinator {

    private var coordinatorData: NewStockPassData { return castPassData(NewStockPassData.self) }

    private weak var outputDelegate: NewStockViewControllerOutputDelegate? = nil

    @discardableResult
    func with(outputDelegate: NewStockViewControllerOutputDelegate) -> NewStockCoordinator {
        self.outputDelegate = outputDelegate
        return self
    }

    override func start() {
        guard let outputDelegate = outputDelegate else { return }

        let controller = NewStockBuilder.generate(with: coordinatorData,
                                                  coordinator: self,
                                                  outputDelegate: outputDelegate)
        navigationController.pushViewController(controller, animated: true)
    }
}
