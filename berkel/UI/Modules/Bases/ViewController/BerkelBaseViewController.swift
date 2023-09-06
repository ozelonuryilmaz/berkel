//
//  BerkelBaseViewController.swift
//  berkel
//
//  Created by Onur Yilmaz on 1.09.2023.
//

import UIKit

class BerkelBaseViewController: UIViewController {
    
    deinit {
        print("killed: \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDidLoad()

    }

    // just base sub class
    internal func initDidLoad() {
        self.setupView()
        self.initialComponents()
        self.registerEvents()
    }
    
    // for all sub class
    func setupView() { }

    // for all sub class
    func initialComponents() { }

    // for all sub class
    func registerEvents() { }
}
