//
//  UserAuthsCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import UIKit

protocol IUserAuthsCoordinator: AnyObject {

}

final class UserAuthsCoordinator: NavigationCoordinator, IUserAuthsCoordinator {

    private var coordinatorData: UserAuthsPassData { return castPassData(UserAuthsPassData.self) }

    override func start() {
        let controller = UserAuthsBuilder.generate(with: coordinatorData,
                                                   coordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}
