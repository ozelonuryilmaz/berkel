//
//  OtherDetailCollectionDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import UIKit

typealias OtherDetailCollectionSnapshot = NSDiffableDataSourceSnapshot<OtherDetailCollectionSection, OtherDetailCollectionRowModel>

final class OtherDetailCollectionDiffableTableView: UITableView {

    private weak var delegateManager: OtherDetailCollectionDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var otherDetailCollectionDataSource: OtherDetailCollectionDataSource = {
        return OtherDetailCollectionDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension OtherDetailCollectionDiffableTableView {

    func configureView(delegateManager: OtherDetailCollectionDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: OtherDetailCollectionSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.otherDetailCollectionDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> OtherDetailCollectionSnapshot {
        return self.otherDetailCollectionDataSource.snapshot()
    }
}

// MARK: Init
private extension OtherDetailCollectionDiffableTableView {

    func initializeTableView() {
        self.registerCell(OtherDetailCollectionTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.delegate = self.otherDetailCollectionDataSource
        self.dataSource = self.otherDetailCollectionDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
