//
//  CavustListDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import UIKit

protocol CavusListDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class CavusListDataSource: UITableViewDiffableDataSource<CavusListSection, CavusListRowModel> {
    weak var outputDelegate: CavusListDataSourceOutputDelegate? = nil
}

extension CavusListDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension CavusListDataSource {

    func applySnapshot(_ snapshot: CavusListSnapshot,
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

