//
//  OtherSellerListDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

protocol OtherSellerListDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class OtherSellerListDataSource: UITableViewDiffableDataSource<OtherSellerListSection, OtherSellerListRowModel> {
    weak var outputDelegate: OtherSellerListDataSourceOutputDelegate? = nil
}

extension OtherSellerListDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension OtherSellerListDataSource {

    func applySnapshot(_ snapshot: OtherSellerListSnapshot,
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

