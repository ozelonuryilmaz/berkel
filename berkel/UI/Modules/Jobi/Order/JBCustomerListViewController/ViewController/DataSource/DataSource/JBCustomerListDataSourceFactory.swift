//
//  JBCustomerListDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import UIKit

protocol JBCustomerListDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IJBCustomerListTableViewCellUIModel)
    func priceTapped(uiModel: IJBCustomerListTableViewCellUIModel)
    func updateTapped(uiModel: IJBCustomerListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(customerId: String)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class JBCustomerListDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: JBCustomerListDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: JBCustomerListDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> JBCustomerListDataSource {

        let dataSource: JBCustomerListDataSource = JBCustomerListDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(JBCustomerListTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - JBCustomerListTableViewCellOutputDelegate
extension JBCustomerListDataSourceFactory: JBCustomerListTableViewCellOutputDelegate {

    func phoneNumberTapped(phoneNumber: String) {
        self.outputDelegate?.phoneNumberTapped(phoneNumber: phoneNumber)
    }
    
    func priceTapped(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.outputDelegate?.priceTapped(uiModel: uiModel)
    }

    func cellTapped(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }

    func archiveTapped(customerId: String) {
        self.outputDelegate?.archiveTapped(customerId: customerId)
    }

    func updateTapped(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.outputDelegate?.updateTapped(uiModel: uiModel)
    }
}

// MARK: - JBCustomerListDataSourceOutputDelegate
extension JBCustomerListDataSourceFactory: JBCustomerListDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
