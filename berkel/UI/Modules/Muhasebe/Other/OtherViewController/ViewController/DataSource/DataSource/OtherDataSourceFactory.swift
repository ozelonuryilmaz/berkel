//
//  OtherDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 28.01.2024.
//

import UIKit

protocol OtherDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOtherTableViewCellUIModel)
    func addCollectionTapped(uiModel: IOtherTableViewCellUIModel)
    func addPaymentTapped(uiModel: IOtherTableViewCellUIModel)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class OtherDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: OtherDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: OtherDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> OtherDataSource {

        let dataSource: OtherDataSource = OtherDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(OtherTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension OtherDataSourceFactory: OtherTableViewCellOutputDelegate {
    
    func cellTapped(uiModel: IOtherTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
    
    func addCollectionTapped(uiModel: IOtherTableViewCellUIModel) {
        self.outputDelegate?.addCollectionTapped(uiModel: uiModel)
    }
    
    func addPaymentTapped(uiModel: IOtherTableViewCellUIModel) {
        self.outputDelegate?.addPaymentTapped(uiModel: uiModel)
    }
}

// MARK: - OtherDataSourceOutputDelegate
extension OtherDataSourceFactory: OtherDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
