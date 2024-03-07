//
//  OtherDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import UIKit

protocol OtherDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class OtherDataSource: UITableViewDiffableDataSource<OtherSection, OtherRowModel> {
    weak var outputDelegate: OtherDataSourceOutputDelegate? = nil
}

extension OtherDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension OtherDataSource {

    func applySnapshot(_ snapshot: OtherSnapshot,
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
