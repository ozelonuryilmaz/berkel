//
//  SellerDetailCollectionDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import UIKit

protocol SellerDetailCollectionDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class SellerDetailCollectionDataSource: UITableViewDiffableDataSource<SellerDetailCollectionSection, SellerDetailCollectionRowModel> {
    weak var outputDelegate: SellerDetailCollectionDataSourceOutputDelegate? = nil
}

extension SellerDetailCollectionDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension SellerDetailCollectionDataSource {

    func applySnapshot(_ snapshot: SellerDetailCollectionSnapshot,
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
