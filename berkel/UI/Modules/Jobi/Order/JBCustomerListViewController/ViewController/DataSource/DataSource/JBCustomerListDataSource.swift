//
//  JBCustomerListDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import UIKit

protocol JBCustomerListDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class JBCustomerListDataSource: UITableViewDiffableDataSource<JBCustomerListSection, JBCustomerListRowModel> {
    weak var outputDelegate: JBCustomerListDataSourceOutputDelegate? = nil
}

extension JBCustomerListDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension JBCustomerListDataSource {

    func applySnapshot(_ snapshot: JBCustomerListSnapshot,
                       animated: Bool = true,
                       completion: (() -> Void)? = nil) {

        if #available(iOS 15.0, *) {
            self.apply(snapshot, animatingDifferences: animated, completion: completion)
        } else {
            if animated {
                self.apply(snapshot, animatingDifferences: true, completion: completion)
            } else {
                UIView.performWithoutAnimation {
                    self.apply(snapshot, animatingDifferences: true, completion: completion)
                }
            }
        }
    }
}
