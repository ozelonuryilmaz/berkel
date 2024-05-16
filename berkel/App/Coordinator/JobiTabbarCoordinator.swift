//
//  JobiTabbarCoordinator.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.03.2024.
//

import UIKit

class JobiTabbarCoordinator: RootableCoordinator {

    var callbackIsPreparedMainScreen: (() -> Void)? = nil

    private lazy var jobiTabbarController: JobiTabbarController = {
        return JobiTabbarController(tabbarControllerDelegate: self)
    }()

    override func start() {

        // Stok
        let stockNavController = MainNavigationController()
        stockNavController.tabBarItem.title = .tab_title_buying
        stockNavController.tabBarItem.image = .tab_title_buying
        stockNavController.tabBarItem.selectedImage = .tab_title_buying_selected
        let stockCoordinator = StockCoordinator(navigationController: stockNavController)

        // Sipariş
        let orderNavController = MainNavigationController()
        orderNavController.tabBarItem.title = .tab_title_worker
        orderNavController.tabBarItem.image = .tab_title_worker
        orderNavController.tabBarItem.selectedImage = .tab_title_worker_selected
        let orderCoordinator = OrderCoordinator(navigationController: orderNavController)

        // Hizmet
        let costNavController = MainNavigationController()
        costNavController.tabBarItem.title = .tab_title_seller
        costNavController.tabBarItem.image = .tab_title_seller
        costNavController.tabBarItem.selectedImage = .tab_title_seller_selected
        let costCoordinator = OtherCoordinator(navigationController: costNavController)

        // Liste
        let jobiListNavController = MainNavigationController()
        jobiListNavController.tabBarItem.title = .tab_title_settings
        jobiListNavController.tabBarItem.image = .tab_title_settings
        jobiListNavController.tabBarItem.selectedImage = .tab_title_settings_selected
        let jobiListCoordinator = SettingsCoordinator(navigationController: jobiListNavController)

        // orderNavController
        jobiTabbarController.viewControllers = [
            stockNavController,
            orderNavController,
            costNavController,
            jobiListNavController
        ]

        window?.rootViewController = jobiTabbarController
        window?.makeKeyAndVisible()

        // Coordinate to first controllers for tabs
        coordinate(to: stockCoordinator)
        coordinate(to: orderCoordinator)
        coordinate(to: costCoordinator)
        coordinate(to: jobiListCoordinator)

        // Uygulamanın ilk açılış ekranı
        self.jobiTabbarController.changeTabbarItemController(position: .stock)

        // uygulamaya giriş yapıldıktan 1 saniye sonra tetiklenen callback
        DispatchQueue.delay(1000) { [weak self] in
            self?.callbackIsPreparedMainScreen?()
        }
    }
}

// MARK: UITabBarControllerDelegate
extension JobiTabbarCoordinator: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        return true
    }
}

// Titles For Tab
fileprivate extension String {
    static var tab_title_buying = "Stok"
    static var tab_title_worker = "Sipariş"
    static var tab_title_seller = "Hizmet"
    static var tab_title_settings = "Liste"
}

// Tab Icons
fileprivate extension UIImage {
    static var tab_title_buying = UIImage(named: "ic_tab_1")!.withRenderingMode(.alwaysTemplate)
    static var tab_title_buying_selected = UIImage(named: "ic_tab_1_selected")!.withRenderingMode(.alwaysOriginal)

    static var tab_title_worker = UIImage(named: "ic_tab_2")!.withRenderingMode(.alwaysTemplate)
    static var tab_title_worker_selected = UIImage(named: "ic_tab_2_selected")!.withRenderingMode(.alwaysOriginal)

    static var tab_title_seller = UIImage(named: "ic_tab_3")!.withRenderingMode(.alwaysTemplate)
    static var tab_title_seller_selected = UIImage(named: "ic_tab_3_selected")!.withRenderingMode(.alwaysOriginal)

    static var tab_title_settings = UIImage(named: "ic_tab_5")!.withRenderingMode(.alwaysTemplate)
    static var tab_title_settings_selected = UIImage(named: "ic_tab_5_selected")!.withRenderingMode(.alwaysOriginal)
}

