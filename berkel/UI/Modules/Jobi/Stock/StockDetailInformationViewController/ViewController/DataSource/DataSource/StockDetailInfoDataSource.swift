//
//  StockDetailInfoDataSource.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//

import UIKit

protocol StockDetailInfoDataSourceOutputDelegate: AnyObject {
    func scrollDidScroll(_ scrollView: UIScrollView)
}

final class StockDetailInfoDataSource: UITableViewDiffableDataSource<StockDetailInfoSection, StockDetailInfoRowModel> {
    weak var outputDelegate: StockDetailInfoDataSourceOutputDelegate? = nil
}

extension StockDetailInfoDataSource: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(scrollView)
    }
}

extension StockDetailInfoDataSource {

    func applySnapshot(_ snapshot: StockDetailInfoSnapshot,
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

