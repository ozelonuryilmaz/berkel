//
//  JobiBaseViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

class JobiBaseViewController: BerkelBaseViewController {

    var jobiTabbarController: JobiTabbarController? {
        return (tabBarController as? JobiTabbarController)
    }

    public var isShowTabbar: Bool {
        return true
    }

    override func initDidLoad() {
        super.initDidLoad()// silmeyin

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // General Configuration
        //visibleTabBar(isVisible: isShowTabbar)
    }
}

