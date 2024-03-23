//
//  Coordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

typealias DefaultDismissCallback = (() -> Void)

protocol ICoordinatorPassData { }

// MARK: Coordinator
protocol Coordinator: AnyObject {

    var passData: ICoordinatorPassData? { set get }
    var willDismissCallback: DefaultDismissCallback? { get set }
    var didDismissCallback: DefaultDismissCallback? { get set }

    func start()

}

extension Coordinator {

    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }

    // Builder pattern
    @discardableResult
    func with(passData: ICoordinatorPassData) -> Coordinator {
        self.passData = passData
        return self
    }

    // Builder pattern
    @discardableResult
    func with(willDismissCallback: DefaultDismissCallback?) -> Coordinator {
        self.willDismissCallback = willDismissCallback
        return self
    }

    // Builder pattern
    @discardableResult
    func with(didDismissCallback: DefaultDismissCallback?) -> Coordinator {
        self.didDismissCallback = didDismissCallback
        return self
    }

    func castPassData<T: ICoordinatorPassData>(_ type: T.Type) -> T {
        guard let passData = passData as? T else { fatalError("undefined pass data struct -> \(T.self)") }
        return passData
    }

    func topViewController() -> UIViewController? {
        return UIApplication.topViewController()
    }
}


// MARK: RootableCoordinator
class RootableCoordinator: NSObject, Coordinator {

    internal var passData: ICoordinatorPassData?
    internal var willDismissCallback: DefaultDismissCallback?
    internal var didDismissCallback: DefaultDismissCallback?

    let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    deinit {
        print("killed: \(type(of: self))")
    }

    func start() {
        fatalError("Start method should be implemented.")
    }
}

// MARK: PresentationCoordinator
class PresentationCoordinator: NSObject, Coordinator {

    deinit {
        print("killed: \(type(of: self))")
    }


    internal var passData: ICoordinatorPassData?
    internal var willDismissCallback: DefaultDismissCallback?
    internal var didDismissCallback: DefaultDismissCallback?

    weak var presenterViewController: UIViewController?

    init(presenterViewController: UIViewController?) {
        self.presenterViewController = presenterViewController
    }

    func start() {
        fatalError("Start method should be implemented.")
    }

    func startPresent(targetVC: UIViewController, animated: Bool = true) {
        presenterViewController?.presentViewController(targetVC, animated: animated)
    }

}

// MARK: NavigationCoordinator
class NavigationCoordinator: NSObject, Coordinator {

    deinit {
        print("killed: \(type(of: self))")
    }

    internal var passData: ICoordinatorPassData?
    internal var willDismissCallback: DefaultDismissCallback?
    internal var didDismissCallback: DefaultDismissCallback?

    internal let navigationController: UINavigationController
    internal var lastViewController: UIViewController? {
        return self.navigationController.lastViewController
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("Start method should be implemented.")
    }

}
