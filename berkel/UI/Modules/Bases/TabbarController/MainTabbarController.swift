//
//  MainTabbarController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

enum MainTabbarItemPosition: Int {
    case buying = 0
    case worker = 1
    case sales = 2
    case settings = 3
    case none = -1
}

final class MainTabbarController: UITabBarController {

    private lazy var customTabbar: BerkelTabBar = {
        let t = BerkelTabBar(frame: tabBar.frame)
        t.makeDefaultAppStyle()
        return t
    }()

    private var tabbarControllerDelegate: UITabBarControllerDelegate?
    private var lastSelectedTabItemPosition: MainTabbarItemPosition = .none

    init(tabbarControllerDelegate: UITabBarControllerDelegate?) {
        self.tabbarControllerDelegate = tabbarControllerDelegate
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(customTabbar, forKey: "tabBar")
        view.backgroundColor = .white
        self.delegate = self.tabbarControllerDelegate
    }

    func changeTabbarItemController(position: MainTabbarItemPosition) {
        // gerekirse eğer delegate ile dışarı aktarma yapılacak.
        self.selectedIndex = position.rawValue

        self.lastSelectedTabItemPosition = position
    }
}

// MARK: Tabbar Methods
extension MainTabbarController {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx,
            let imageView = tabBar.subviews[idx].subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }

        imageView.bounceAnimation()

        // calculate selected position
        let selectedTabItemPosition = MainTabbarItemPosition(rawValue: idx) ?? .none

        // son tıklanan tutuluyor.
        self.lastSelectedTabItemPosition = selectedTabItemPosition
    }
}
