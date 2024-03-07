//
//  OtherSellerListDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

protocol OtherSellerListDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOtherSellerListTableViewCellUIModel)
    func updateTapped(uiModel: IOtherSellerListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(otherSellerId: String)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class OtherSellerListDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: OtherSellerListDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: OtherSellerListDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> OtherSellerListDataSource {

        let dataSource: OtherSellerListDataSource = OtherSellerListDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(OtherSellerListTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - OtherSellerListTableViewCellOutputDelegate
extension OtherSellerListDataSourceFactory: OtherSellerListTableViewCellOutputDelegate {

    func phoneNumberTapped(phoneNumber: String) {
        self.outputDelegate?.phoneNumberTapped(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: IOtherSellerListTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }

    func archiveTapped(otherSellerId: String) {
        self.outputDelegate?.archiveTapped(otherSellerId: otherSellerId)
    }

    func updateTapped(uiModel: IOtherSellerListTableViewCellUIModel) {
        self.outputDelegate?.updateTapped(uiModel: uiModel)
    }
}

// MARK: - OtherSellerListDataSourceOutputDelegate
extension OtherSellerListDataSourceFactory: OtherSellerListDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
