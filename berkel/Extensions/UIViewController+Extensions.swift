//
//  UIViewController+Extensions.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

extension UIViewController {

    var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }

    static func instantiateFromNibOrSelfIntance() -> Self {
        func instantiateFromNibOrSelfIntance<T: UIViewController>(_ viewType: T.Type) -> T {
            guard let _ = Bundle.main.path(forResource: String(describing: T.self), ofType: "nib") else {
                return T.init()
            }
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNibOrSelfIntance(self)
    }

    func hideKeyboard() {
        self.view.hideKeyboard()
    }
    
    func setBackButtonTitle(title: String) {
        let backButton = BackBarButtonItem(title: title, style: .plain)
        backButton.tintColor = navigationController?.navigationBar.tintColor
        navigationItem.backBarButtonItem = backButton
    }

    func visibleTabBar(isVisible: Bool) {
        self.tabBarController?.tabBar.isHidden = !isVisible
    }

    func visibleNavigationBar(isVisible: Bool, animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(!isVisible, animated: animated)
    }

    // shareContent -> [text or url or image] or hepsi aynı anda da olabilir.
    // refactore sürecine girersek, bunu coordinator'a çevirebiliriz.
    func openShareUIActivityViewController(shareContent: [Any]) {
        let activityController = UIActivityViewController(activityItems: shareContent,
                                                          applicationActivities: nil)

        // IPAD'de farklı çalışıyor, crash vermemesi için bu ayarlar gerekiyor
        // sourceView ve sourceRect normalde basılan buton vs yapılır.
        // ama self.view yaptım ve denemedim. problem olursa değişiriz.
        // dışardan tıklanan butonu sender view olarak alırız.
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = self.view
            activityController.popoverPresentationController?.sourceRect = self.view.bounds
            activityController.popoverPresentationController?.permittedArrowDirections = [.any]
        }
        self.present(activityController, animated: true, completion: nil)
    }

    func openUrl(url: String) {
        if let url = URL(string: url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    func transitionViewController(vc: UIViewController, duration: CFTimeInterval = 0.5, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = createTransitionAnimation(duration: duration, type: type)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }

    func transitionDismiss(duration: CFTimeInterval = 0.3, type: CATransitionSubtype) {
        let transition = createTransitionAnimation(duration: duration, type: type)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }

    private func createTransitionAnimation(duration: CFTimeInterval, type: CATransitionSubtype) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        return transition
    }

    func presentViewController(_ viewControllerToPresent: UIViewController, animated: Bool = true) {
        self.present(viewControllerToPresent, animated: animated, completion: nil)
    }

    func pushViewControllerToNavigationController(_ viewControllerToPresent: UIViewController, isAnimated: Bool = true) {
        self.navigationController?.pushViewController(viewControllerToPresent, animated: isAnimated)
    }

    func selfDismiss(completion: (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }

    func selfPopViewController(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }

    func selfPopToRootViewController(animated: Bool = false) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

}

enum AlertPreferredActionType {
    case positive
    case negative
    case nothing
}

// MARK: Alert
extension UIViewController {

    func showInformationAlert(
        message: String,
        positiveButtonClickListener: (() -> Void)? = nil) {

        showSystemAlert(title: "Bilgi",
                        message: message,
                        positiveButtonClickListener: positiveButtonClickListener)
    }

    func showSuccessAlert(
        message: String,
        positiveButtonClickListener: (() -> Void)? = nil) {

        showSystemAlert(title: "Başarılı",
                        message: message,
                        positiveButtonClickListener: positiveButtonClickListener)
    }

    func showErrorAlert(
        title: String?,
        errorMessage: String,
        positiveButtonClickListener: (() -> Void)? = nil) {

        showSystemAlert(title: title ?? "Tekrar Deneyiniz",
                        message: errorMessage,
                        positiveButtonText: "Tamam",
                        positiveButtonClickListener: positiveButtonClickListener,
                        negativeButtonText: "Vazgeç")
    }

    func showWarningAlert(
        message: String,
        positiveButtonClickListener: (() -> Void)? = nil) {

        showSystemAlert(title: "Uyarı",
                        message: message,
                        positiveButtonClickListener: positiveButtonClickListener)
    }

    func showSystemAlert(
        title: String,
        message: String,
        positiveButtonText: String? = "Tamam",
        positiveButtonClickListener: (() -> Void)? = nil,
        negativeButtonText: String? = nil,
        negativeButtonClickListener: (() -> Void)? = nil,
        preferredActionType: AlertPreferredActionType = .nothing,
        tintColor: UIColor = .primaryBlue
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = tintColor

        // Positive Action
        let posAction = UIAlertAction(title: positiveButtonText, style: .default,
                                      handler: { _ in
                                          positiveButtonClickListener?()
                                      })
        alert.addAction(posAction)

        // Negative Action
        var negAction: UIAlertAction? = nil
        if let negativeButtonText = negativeButtonText {
            negAction = UIAlertAction(title: negativeButtonText, style: .cancel,
                                      handler: { _ in
                                          negativeButtonClickListener?()
                                      })
            alert.addAction(negAction!)
        }

        switch preferredActionType {
        case .positive:
            alert.preferredAction = posAction
        case .negative:
            alert.preferredAction = negAction
        case .nothing:
            alert.preferredAction = nil
        }

        present(alert, animated: true, completion: nil)
    }

    func showSystemActionSheet(title: String? = nil,
                               message: String? = nil,
                               actionSheetItems: [ActionSheetItem],
                               tintColor: UIColor = .primaryBlue) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.view.tintColor = tintColor

        actionSheetItems.forEach { (actionSheetItem) in
            alertController.addAction(UIAlertAction(title: actionSheetItem.title,
                                                    style: actionSheetItem.style,
                                                    handler: actionSheetItem.action))
        }

        alertController.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))

        present(alertController, animated: true, completion: nil)
    }
}


// MARK: ActionSheet
extension UIViewController {
    func showActionSheetAlert(title: String?,
                              message: String?,
                              actionSheetItems: [ActionSheetItem],
                              isShowCancelAction: Bool = false,
                              tintColor: UIColor? = .primaryBlue) {
        let alertSheet = UIAlertController(title: title, message: message, preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        alertSheet.view.tintColor = tintColor

        actionSheetItems.forEach { (actionSheetItem) in
            alertSheet.addAction(UIAlertAction(title: actionSheetItem.title,
                                               style: .default,
                                               handler: actionSheetItem.action))
        }

        if isShowCancelAction {
            alertSheet.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        }

        present(alertSheet, animated: true, completion: nil)
    }
}


// MARK: Toast Messages
extension UIViewController {

    func showToast(message: String, position: ToastPosition = .bottom, messageAligment: NSTextAlignment = .left) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.darkGray
        style.messageColor = UIColor.white
        style.messageAlignment = messageAligment
        self.view.makeToast(message, position: position, style: style)
    }

    func showToast(_ toast: UIView, duration: TimeInterval = 5.0, position: ToastPosition = .bottom, completion: ((_ didTap: Bool) -> Void)? = nil) {
        self.hideAllToast()
        self.navigationController?.view.showToast(toast, duration: duration, position: position, completion: completion)
    }

    func hideAllToast() {
        self.navigationController?.view.hideAllToasts()
    }
}


// MARK: UIViewController+Extensions içerisinde kullanılıyor.
class ActionSheetItem {
    var title: String
    var style: UIAlertAction.Style = .default
    var action: (UIAlertAction) -> Void

    init(title: String,
         style: UIAlertAction.Style = .default,
         action: @escaping (UIAlertAction) -> Void) {

        self.title = title
        self.style = style
        self.action = action
    }
}
