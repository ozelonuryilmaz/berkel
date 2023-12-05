//
//  CustomerListDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit

protocol CustomerListDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: ICustomerListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(customerId: String)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class CustomerListDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: CustomerListDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: CustomerListDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> CustomerListDataSource {

        let dataSource: CustomerListDataSource = CustomerListDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(CustomerListTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - CustomerListTableViewCellOutputDelegate
extension CustomerListDataSourceFactory: CustomerListTableViewCellOutputDelegate {

    func phoneNumberTapped(phoneNumber: String) {
        self.outputDelegate?.phoneNumberTapped(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: ICustomerListTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
    
    func archiveTapped(customerId: String) {
        self.outputDelegate?.archiveTapped(customerId: customerId)
    }
}

// MARK: - CustomerListDataSourceOutputDelegate
extension CustomerListDataSourceFactory: CustomerListDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
