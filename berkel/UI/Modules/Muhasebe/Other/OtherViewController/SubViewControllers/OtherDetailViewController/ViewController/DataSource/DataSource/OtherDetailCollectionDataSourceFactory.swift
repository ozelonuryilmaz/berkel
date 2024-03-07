//
//  OtherDetailCollectionDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.02.2024.
//

import UIKit

protocol OtherDetailCollectionDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOtherDetailCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
}

final class OtherDetailCollectionDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: OtherDetailCollectionDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: OtherDetailCollectionDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> OtherDetailCollectionDataSource {

        let dataSource: OtherDetailCollectionDataSource = OtherDetailCollectionDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(OtherDetailCollectionTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension OtherDetailCollectionDataSourceFactory: OtherDetailCollectionTableViewCellOutputDelegate {

    func cellTapped(uiModel: IOtherDetailCollectionTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }

    func calcActivateTapped(id: String, date: String, isCalc: Bool) {
        self.outputDelegate?.calcActivateTapped(id: id, date: date, isCalc: isCalc)
    }
}

// MARK: - OtherDetailCollectionDataSourceOutputDelegate
extension OtherDetailCollectionDataSourceFactory: OtherDetailCollectionDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        //self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
