//
//  AddBuyingItemDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol AddBuyingItemDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class AddBuyingItemDataSource: UITableViewDiffableDataSource<AddBuyingItemSection, AddBuyingItemRowModel> {
    weak var outputDelegate: AddBuyingItemDataSourceOutputDelegate? = nil
}

extension AddBuyingItemDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension AddBuyingItemDataSource {

    func applySnapshot(_ snapshot: AddBuyingItemSnapshot,
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
