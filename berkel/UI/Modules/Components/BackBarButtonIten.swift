//
//  BackBarButtonIten.swift
//  berkel
//
//  Created by Onur Yilmaz on 12.09.2023.
//

import UIKit

class BackBarButtonItem: UIBarButtonItem {

    // Long Press Context Menu Kapatıldı.
    @available(iOS 14.0, *)
    override var menu: UIMenu? {
        set {
            /* Don't set the menu here */
            /* super.menu = menu */
        }
        get { return super.menu }
    }
}

