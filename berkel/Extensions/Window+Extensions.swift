//
//  Window+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

extension UIWindow {

    func topViewController() -> UIViewController? {
        return topViewController(self.rootViewController)
    }

    private func topViewController(_ base: UIViewController?) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }

        return base
    }

}
