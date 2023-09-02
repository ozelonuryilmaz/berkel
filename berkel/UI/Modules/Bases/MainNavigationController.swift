//
//  MainNavigationController.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.09.2023.
//

import Foundation

import UIKit

class MainNavigationController: UINavigationController {

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        initialComponents()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialComponents()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialComponents()
    }

    private func initialComponents() {
        self.view.backgroundColor = .white // navigation large modda geçişlerde siyahlık görünüyor, bu yüzden bu kodu silmeyin.

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.backgroundImage = UIImage()

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance

        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .primaryBlue
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
