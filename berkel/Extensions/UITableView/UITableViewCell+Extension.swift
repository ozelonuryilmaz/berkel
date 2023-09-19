//
//  UITableViewCell+Extension.swift
//  EmlakjetIndividual
//
//  Created by Onur Yilmaz on 30.03.2022.
//

import UIKit

extension UITableViewCell {

    func showSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    func hideSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        }
    }
    
    func enable(on: Bool) {
        contentView.alpha = on ? 1 : 0.5
        contentView.isUserInteractionEnabled = on
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
        }
    }
    
    class func reuseIdentifier() -> String {
        let className = String.init(describing: self)
        return className
    }
}
