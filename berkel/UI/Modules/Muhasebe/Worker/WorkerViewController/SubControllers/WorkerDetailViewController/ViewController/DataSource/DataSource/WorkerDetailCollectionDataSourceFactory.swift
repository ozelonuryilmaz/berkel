//
//  WorkerDetailCollectionDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import UIKit

protocol WorkerDetailCollectionDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IWorkerDetailCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
}

final class WorkerDetailCollectionDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: WorkerDetailCollectionDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: WorkerDetailCollectionDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> WorkerDetailCollectionDataSource {

        let dataSource: WorkerDetailCollectionDataSource = WorkerDetailCollectionDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(WorkerDetailCollectionTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension WorkerDetailCollectionDataSourceFactory: WorkerDetailCollectionTableViewCellOutputDelegate {

    func cellTapped(uiModel: IWorkerDetailCollectionTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }

    func calcActivateTapped(id: String, date: String, isCalc: Bool) {
        self.outputDelegate?.calcActivateTapped(id: id, date: date, isCalc: isCalc)
    }
}

// MARK: - WorkerDetailCollectionDataSourceOutputDelegate
extension WorkerDetailCollectionDataSourceFactory: WorkerDetailCollectionDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        //self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
