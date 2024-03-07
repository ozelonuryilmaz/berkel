//
//  WorkerDetailCollectionDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import UIKit

typealias WorkerDetailCollectionSnapshot = NSDiffableDataSourceSnapshot<WorkerDetailCollectionSection, WorkerDetailCollectionRowModel>

final class WorkerDetailCollectionDiffableTableView: UITableView {

    private weak var delegateManager: WorkerDetailCollectionDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var workerDetailCollectionDataSource: WorkerDetailCollectionDataSource = {
        return WorkerDetailCollectionDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension WorkerDetailCollectionDiffableTableView {

    func configureView(delegateManager: WorkerDetailCollectionDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: WorkerDetailCollectionSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.workerDetailCollectionDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> WorkerDetailCollectionSnapshot {
        return self.workerDetailCollectionDataSource.snapshot()
    }
}

// MARK: Init
private extension WorkerDetailCollectionDiffableTableView {

    func initializeTableView() {
        self.registerCell(WorkerDetailCollectionTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.delegate = self.workerDetailCollectionDataSource
        self.dataSource = self.workerDetailCollectionDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
