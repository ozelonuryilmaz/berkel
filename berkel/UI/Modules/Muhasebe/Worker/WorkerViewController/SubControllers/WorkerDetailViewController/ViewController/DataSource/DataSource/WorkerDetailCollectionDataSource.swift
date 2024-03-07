//
//  WorkerDetailCollectionDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import UIKit

protocol WorkerDetailCollectionDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class WorkerDetailCollectionDataSource: UITableViewDiffableDataSource<WorkerDetailCollectionSection, WorkerDetailCollectionRowModel> {
    weak var outputDelegate: WorkerDetailCollectionDataSourceOutputDelegate? = nil
}

extension WorkerDetailCollectionDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension WorkerDetailCollectionDataSource {

    func applySnapshot(_ snapshot: WorkerDetailCollectionSnapshot,
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
