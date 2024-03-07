//
//  OtherDetailCollectionDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import UIKit

protocol OtherDetailCollectionDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class OtherDetailCollectionDataSource: UITableViewDiffableDataSource<OtherDetailCollectionSection, OtherDetailCollectionRowModel> {
    weak var outputDelegate: OtherDetailCollectionDataSourceOutputDelegate? = nil
}

extension OtherDetailCollectionDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension OtherDetailCollectionDataSource {

    func applySnapshot(_ snapshot: OtherDetailCollectionSnapshot,
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
