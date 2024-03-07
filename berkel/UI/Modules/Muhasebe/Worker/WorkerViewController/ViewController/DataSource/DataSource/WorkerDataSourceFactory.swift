//
//  WorkerDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.11.2023.
//

import UIKit

protocol WorkerDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IWorkerTableViewCellUIModel)
    func addCollectionTapped(uiModel: IWorkerTableViewCellUIModel)
    func addPaymentTapped(uiModel: IWorkerTableViewCellUIModel)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class WorkerDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: WorkerDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: WorkerDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> WorkerDataSource {

        let dataSource: WorkerDataSource = WorkerDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(WorkerTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension WorkerDataSourceFactory: WorkerTableViewCellOutputDelegate {
    
    func cellTapped(uiModel: IWorkerTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
    
    func addCollectionTapped(uiModel: IWorkerTableViewCellUIModel) {
        self.outputDelegate?.addCollectionTapped(uiModel: uiModel)
    }
    
    func addPaymentTapped(uiModel: IWorkerTableViewCellUIModel) {
        self.outputDelegate?.addPaymentTapped(uiModel: uiModel)
    }
}

// MARK: - WorkerDataSourceOutputDelegate
extension WorkerDataSourceFactory: WorkerDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
