//
//  MainTabbarCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import UIKit

class MainTabbarCoordinator: RootableCoordinator {

    var callbackIsPreparedMainScreen: (() -> Void)? = nil

    private lazy var mainTabbarController: MainTabbarController = {
        return MainTabbarController(tabbarControllerDelegate: self)
    }()

    override func start() {

        // Buying
        let buyingNavController = MainNavigationController()
        buyingNavController.tabBarItem.title = .tab_title_buying
        buyingNavController.tabBarItem.image = .tab_title_buying
        buyingNavController.tabBarItem.selectedImage = .tab_title_buying_selected
        let buyingCoordinator = BuyingCoordinator(navigationController: buyingNavController)

        // Worker
        let workerNavController = MainNavigationController()
        workerNavController.tabBarItem.title = .tab_title_worker
        workerNavController.tabBarItem.image = .tab_title_worker
        workerNavController.tabBarItem.selectedImage = .tab_title_worker_selected
        let workerCoordinator = WorkerCoordinator(navigationController: workerNavController)

        // Seller
        let sellerNavController = MainNavigationController()
        sellerNavController.tabBarItem.title = .tab_title_seller
        sellerNavController.tabBarItem.image = .tab_title_seller
        sellerNavController.tabBarItem.selectedImage = .tab_title_seller_selected
        let sellerCoordinator = SellerCoordinator(navigationController: sellerNavController)

        // Settings
        let settingsNavController = MainNavigationController()
        settingsNavController.tabBarItem.title = .tab_title_settings
        settingsNavController.tabBarItem.image = .tab_title_settings
        settingsNavController.tabBarItem.selectedImage = .tab_title_settings_selected
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNavController)

        // workerNavController
        mainTabbarController.viewControllers = [
            buyingNavController,
            workerNavController,
            sellerNavController,
            settingsNavController
        ]

        window?.rootViewController = mainTabbarController
        window?.makeKeyAndVisible()

        // Coordinate to first controllers for tabs
        coordinate(to: buyingCoordinator)
        coordinate(to: workerCoordinator)
        coordinate(to: sellerCoordinator)
        coordinate(to: settingsCoordinator)

        // Uygulamanın ilk açılış ekranı
        self.mainTabbarController.changeTabbarItemController(position: .buying)

        // uygulamaya giriş yapıldıktan 1 saniye sonra tetiklenen callback
        DispatchQueue.delay(1000) { [weak self] in
            self?.callbackIsPreparedMainScreen?()
        }
    }
}

// MARK: UITabBarControllerDelegate
extension MainTabbarCoordinator: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        return true
    }
}

// Titles For Tab
fileprivate extension String {
    static var tab_title_buying = "Alış"
    static var tab_title_worker = "İşçi"
    static var tab_title_seller = "Satış"
    static var tab_title_settings = "Ayarlar"
}

// Tab Icons
fileprivate extension UIImage {
    static var tab_title_buying = UIImage(named: "ic_tab_1")!.withRenderingMode(.alwaysOriginal)
    static var tab_title_buying_selected = UIImage(named: "ic_tab_1_selected")!.withRenderingMode(.alwaysOriginal)

    static var tab_title_worker = UIImage(named: "ic_tab_2")!.withRenderingMode(.alwaysOriginal)
    static var tab_title_worker_selected = UIImage(named: "ic_tab_2_selected")!.withRenderingMode(.alwaysOriginal)

    static var tab_title_seller = UIImage(named: "ic_tab_3")!.withRenderingMode(.alwaysOriginal)
    static var tab_title_seller_selected = UIImage(named: "ic_tab_3_selected")!.withRenderingMode(.alwaysOriginal)

    static var tab_title_settings = UIImage(named: "ic_tab_4")!.withRenderingMode(.alwaysOriginal)
    static var tab_title_settings_selected = UIImage(named: "ic_tab_4_selected")!.withRenderingMode(.alwaysOriginal)
}

