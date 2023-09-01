//
//  Window+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

extension UIWindow {

    func topViewControllerNew() -> UIViewController? {
        return topViewControllerNew(self.rootViewController)
    }

    private func topViewControllerNew(_ base: UIViewController?) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewControllerNew(nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewControllerNew(selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewControllerNew(presented)
        }

        return base
    }

}
