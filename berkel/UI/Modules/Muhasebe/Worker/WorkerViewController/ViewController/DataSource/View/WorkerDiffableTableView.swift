//
//  WorkerDiffableTableView.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

typealias WorkerSnapshot = NSDiffableDataSourceSnapshot<WorkerSection, WorkerRowModel>

final class WorkerDiffableTableView: UITableView {

    private weak var delegateManager: WorkerDataSourceFactoryOutputDelegate? = nil

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private lazy var workerDataSource: WorkerDataSource = {
        return WorkerDataSourceFactory(tableView: self, outputDelegate: self.delegateManager)
            .makeDataSource()
    }()
}

// MARK: Management
extension WorkerDiffableTableView {

    func configureView(delegateManager: WorkerDataSourceFactoryOutputDelegate) {
        self.delegateManager = delegateManager
        self.initializeTableView()
    }

    func applySnapshot(_ snapshot: WorkerSnapshot,
                       animated: Bool = false,
                       completion: (() -> Void)? = nil) {

        self.workerDataSource.applySnapshot(snapshot,
                                                   animated: animated,
                                                   completion: completion)
    }

    func getSnapshot() -> WorkerSnapshot {
        return self.workerDataSource.snapshot()
    }
}

// MARK: Init
private extension WorkerDiffableTableView {

    func initializeTableView() {
        self.registerCell(WorkerTableViewCell.self)
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.delegate = self.workerDataSource
        self.dataSource = self.workerDataSource
        self.removeTableFooterView()

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
