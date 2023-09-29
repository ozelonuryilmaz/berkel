//
//  BuyingDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 29.09.2023.
//

import UIKit

protocol BuyingDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class BuyingDataSource: UITableViewDiffableDataSource<BuyingSection, BuyingRowModel> {
    weak var outputDelegate: BuyingDataSourceOutputDelegate? = nil
}

extension BuyingDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension BuyingDataSource {

    func applySnapshot(_ snapshot: BuyingSnapshot,
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
