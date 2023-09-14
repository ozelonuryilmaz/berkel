//
//  UINavigationController+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

extension UINavigationController {

    var lastViewController: UIViewController? {
        return viewControllers.last
    }

    public var navigationBarHeight: CGFloat {
        return navigationBar.height
    }

    public var navigationBarWidth: CGFloat {
        return navigationBar.width
    }

    func setRootViewController(viewController: UIViewController) {
        self.viewControllers = [viewController]
    }

    /**
     Pop current view controller to previous view controller.

     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func popWithAnimation(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 0.5) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }

    /**
     Push a new view controller on the view controllers's stack.

     - parameter vc:       view controller to push.
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func pushWithAnimation(viewController vc: UIViewController, transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }

    private func addTransition(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 0.5) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType(rawValue: type)
        self.view.layer.add(transition, forKey: nil)
    }
}

extension UINavigationItem {

    func setCustomTitle(_ title: String, subtitle: String) {

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .blackColor
        titleLabel.lineBreakMode = .byTruncatingHead

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .boldSystemFont(ofSize: 14)
        subtitleLabel.textColor = .primaryBlue

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 2

        self.titleView = stackView
    }
}
