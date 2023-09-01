//
//  UIView+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

extension UIView {

    func addTapAction(_ target: Any?, action: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UIGestureRecognizer(target: target, action: action))
    }

    // ** Loads instance from nib with the same name. */
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        print(nibName)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

extension UIView {

    public var height: CGFloat {
        return frame.size.height
    }

    public var width: CGFloat {
        return frame.size.width
    }

    func hideKeyboard() {
        endEditing(true)
    }

    func visible(_ visible: Bool) {
        isHidden = !visible
    }

    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }

    // custom nav bar olan yerlerde çalışmıyor.
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = WindowHelper.getWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }

    func isDarkModeInterfaceStyle() -> Bool {
        if traitCollection.userInterfaceStyle == .light {
            return false
        } else {
            return true
        }
    }

    func setDefaultShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }

    func setDefaultFlurShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        layer.shadowRadius = 3.5
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }

    func setShadowLikeCardView() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }

    func setDefaultFlurShadowLikeCardView() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
    }

    func removeFromSuperviewWithConstraints() {
        self.removeFromSuperview()
        if self.constraints.count > 0 {
            self.removeConstraints(self.constraints)
        }
    }

    func addShadow(top: Bool, left: Bool, bottom: Bool, right: Bool, shadowRadius: CGFloat = 2.0, shadowOpacity: Float = 1.0) {

        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 2
        var viewWidth = UIScreen.main.bounds.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y += (shadowRadius + 1)
        }
        if (!bottom) {
            viewHeight -= (shadowRadius + 1)
        }
        if (!left) {
            x += (shadowRadius + 1)
        }
        if (!right) {
            viewWidth -= (shadowRadius + 1)
        }

        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        path.close()
        self.layer.shadowPath = path.cgPath
    }

    func giveShadow(shadowRadius: CGFloat = 2,
                    opacity: Float = 1,
                    shadowOffset: CGSize = CGSize(width: 0, height: 2),
                    shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.22)) {
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func parentController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.parentController()
        } else {
            return nil
        }
    }

    func borderAndCorner(radius: CGFloat, color: UIColor, width: Int) {
        layer.cornerRadius = radius
        layer.borderWidth = CGFloat(width)
        layer.borderColor = color.cgColor
    }

    func roundCornersEachCorner(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }

}

// MARK: for Animations
extension UIView {

    func bounceAnimation() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.3, 0.9, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        layer.add(bounceAnimation, forKey: "m_bounce")
    }

    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }

    func blinkAnimation() {
        self.animatedAlpha(from: 0.3, to: 1.0, withDuration: 0.6)
    }

    // like button highlight
    func animatedAlpha(from: CGFloat, to: CGFloat, withDuration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            self.alpha = from
            UIView.animate(withDuration: withDuration, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = to
            }, completion: nil)
        }
    }

    func changeBackgroundColorWithAnimation(color: UIColor?) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
            self.backgroundColor = color
        }, completion: nil)
    }

    func changeBackgroundColorWithAlphaAnimation(color: UIColor?, from: CGFloat, to: CGFloat) {
        DispatchQueue.main.async {
            self.alpha = from
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
                self.backgroundColor = color
                self.alpha = to
            }, completion: nil)
        }
    }
}

// MARK: for Constraints
extension UIView {

    var topConstaint: NSLayoutConstraint? {
        get {
            return findConstraint(layoutAttribute: .top)
        }
        set { setNeedsLayout() }
    }

    var leadingConstaint: NSLayoutConstraint? {
        get {
            return findConstraint(layoutAttribute: .leading)
        }
        set { setNeedsLayout() }
    }

    var bottomConstraint: NSLayoutConstraint? {
        get {
            return findConstraint(layoutAttribute: .bottom)
        }
        set { setNeedsLayout() }
    }

    var trailingConstaint: NSLayoutConstraint? {
        get {
            return findConstraint(layoutAttribute: .trailing)
        }
        set { setNeedsLayout() }
    }

    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }

    private func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        if let firstItem = constraint.firstItem as? UIView, let secondItem = constraint.secondItem as? UIView {
            let firstItemMatch = firstItem == self && constraint.firstAttribute == layoutAttribute
            let secondItemMatch = secondItem == self && constraint.secondAttribute == layoutAttribute
            return firstItemMatch || secondItemMatch
        }
        return false
    }
}


extension UIView {
    static func generateGenericLabel(withFont font: UIFont! = UIFont.systemFont(ofSize: 14),
                                     withTextAlignment textAlignent: NSTextAlignment! = .left,
                                     withLineBreakmode lineBreakmode: NSLineBreakMode! = .byTruncatingTail,
                                     withNumberOfLines numberOfLines: Int! = 1,
                                     withTextColor textColor: UIColor! = .blackColor,
                                     withText text:String? = nil) -> UILabel {
        let v = UILabel(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.lineBreakMode = lineBreakmode
        v.numberOfLines = numberOfLines
        v.textColor = textColor
        v.textAlignment = textAlignent
        v.font = font

        return v
    }
    
    static func generateGenericButton(withText text:String! = "") -> UIButton {
        let v = UIButton(type: .system)
        v.setTitle(text, for: .normal)
        return v
    }
    
    func removeShadow() {
        layer.shadowOffset = CGSize(width: 0 , height: 0)
        layer.shadowColor = UIColor.clear.cgColor
        layer.cornerRadius = 0.0
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.0
    }
}
