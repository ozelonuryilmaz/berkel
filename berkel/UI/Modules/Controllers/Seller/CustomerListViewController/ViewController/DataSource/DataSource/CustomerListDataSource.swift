//
//  CustomerListDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit

protocol CustomerListDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class CustomerListDataSource: UITableViewDiffableDataSource<CustomerListSection, CustomerListRowModel> {
    weak var outputDelegate: CustomerListDataSourceOutputDelegate? = nil
}

extension CustomerListDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension CustomerListDataSource {

    func applySnapshot(_ snapshot: CustomerListSnapshot,
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

