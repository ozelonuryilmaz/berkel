//
//  UIApplication+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

extension UIApplication {

    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }

    static func topViewController() -> UIViewController? {
        return WindowHelper.getWindow()?.topViewController()
    }
    
    static func getBottomSafeAreaInset() -> CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            return window.safeAreaInsets.bottom
        } else {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.bottom ?? 0
        }
    }
}
