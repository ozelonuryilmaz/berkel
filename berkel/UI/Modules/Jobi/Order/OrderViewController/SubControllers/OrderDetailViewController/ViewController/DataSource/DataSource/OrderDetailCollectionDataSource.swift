//
//  OrderDetailCollectionDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import UIKit

protocol OrderDetailCollectionDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class OrderDetailCollectionDataSource: UITableViewDiffableDataSource<OrderDetailCollectionSection, OrderDetailCollectionRowModel> {
    weak var outputDelegate: OrderDetailCollectionDataSourceOutputDelegate? = nil
}

extension OrderDetailCollectionDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension OrderDetailCollectionDataSource {

    func applySnapshot(_ snapshot: OrderDetailCollectionSnapshot,
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
