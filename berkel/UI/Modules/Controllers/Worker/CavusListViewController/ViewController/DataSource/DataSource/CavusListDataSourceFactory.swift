//
//  CavusListDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import UIKit

protocol CavusListDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: ICavusListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class CavusListDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: CavusListDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: CavusListDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> CavusListDataSource {

        let dataSource: CavusListDataSource = CavusListDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(CavusListTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension CavusListDataSourceFactory: CavusListTableViewCellOutputDelegate {

    func phoneNumberTapped(phoneNumber: String) {
        self.outputDelegate?.phoneNumberTapped(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: ICavusListTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
}

// MARK: - CavusListDataSourceOutputDelegate
extension CavusListDataSourceFactory: CavusListDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
