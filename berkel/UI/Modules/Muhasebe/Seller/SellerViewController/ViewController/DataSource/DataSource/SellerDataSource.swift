//
//  SellerDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.11.2023.
//

import UIKit

protocol SellerDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class SellerDataSource: UITableViewDiffableDataSource<SellerSection, SellerRowModel> {
    weak var outputDelegate: SellerDataSourceOutputDelegate? = nil
}

extension SellerDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension SellerDataSource {

    func applySnapshot(_ snapshot: SellerSnapshot,
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
