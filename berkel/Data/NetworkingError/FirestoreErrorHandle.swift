//
//  FirestoreErrorHandle.swift
//  berkel
//
//  Created by Onur Yilmaz on 9.09.2023.
//

import UIKit

typealias CallbackOverrideAlert = ((_ errorMessage: String) -> Void)

class FirestoreErrorHandle {

    private weak var viewController: UIViewController?
    // alert gösterilmeden custom bir çalışma yapılabilir
    private var callbackOverrideAlert: CallbackOverrideAlert? = nil
    // alert gösterilir ve tamam butonuna tıklanıldığında bir çalışma yapılabilir
    private var callbackAlertButtonAction: (() -> Void)? = nil

    init(viewController: UIViewController?,
         callbackOverrideAlert: CallbackOverrideAlert? = nil,
         callbackAlertButtonAction: (() -> Void)? = nil) {
        self.viewController = viewController
        self.callbackOverrideAlert = callbackOverrideAlert
        self.callbackAlertButtonAction = callbackAlertButtonAction
    }

    func handleCommonError(title: String?, errorMessage: String) {
        if let callbackOverrideAlert = callbackOverrideAlert {
            callbackOverrideAlert(errorMessage)
        } else {
            showDefaultAlert(title: title, errorMessage: errorMessage)
        }
    }

    private func showDefaultAlert(title: String?, errorMessage: String?) {
        viewController?.showErrorAlert(title: title, errorMessage: errorMessage ?? "") { [weak self] in // positive button click
            self?.callbackAlertButtonAction?()
        }
    }
}
