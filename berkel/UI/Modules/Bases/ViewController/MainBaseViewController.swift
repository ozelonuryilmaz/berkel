//
//  MainBaseViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import Foundation

class MainBaseViewController: BerkelBaseViewController {

    var mainTabbarController: MainTabbarController? {
        return (tabBarController as? MainTabbarController)
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
        visibleTabBar(isVisible: isShowTabbar)
    }
}

