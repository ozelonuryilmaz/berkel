//
//  BuyingCollectionDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol BuyingCollectionDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class BuyingCollectionDataSource: UITableViewDiffableDataSource<BuyingCollectionSection, BuyingCollectionRowModel> {
    weak var outputDelegate: BuyingCollectionDataSourceOutputDelegate? = nil
}

extension BuyingCollectionDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension BuyingCollectionDataSource {

    func applySnapshot(_ snapshot: BuyingCollectionSnapshot,
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
