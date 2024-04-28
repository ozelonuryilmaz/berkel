//
//  OrderDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.04.2024.
//

import UIKit

protocol OrderDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class OrderDataSource: UITableViewDiffableDataSource<OrderSection, OrderRowModel> {
    weak var outputDelegate: OrderDataSourceOutputDelegate? = nil
}

extension OrderDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension OrderDataSource {

    func applySnapshot(_ snapshot: OrderSnapshot,
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
