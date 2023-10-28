//
//  AddBuyingItemDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol AddBuyingItemDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IAddBuyingItemTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(sellerId: String)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class AddBuyingItemDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: AddBuyingItemDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: AddBuyingItemDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> AddBuyingItemDataSource {

        let dataSource: AddBuyingItemDataSource = AddBuyingItemDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(AddBuyingItemTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.hideSeparator()
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension AddBuyingItemDataSourceFactory: AddBuyingItemTableViewCellOutputDelegate {

    func archiveTapped(sellerId: String) {
        self.outputDelegate?.archiveTapped(sellerId: sellerId)
    }

    func phoneNumberTapped(phoneNumber: String) {
        self.outputDelegate?.phoneNumberTapped(phoneNumber: phoneNumber)
    }

    func cellTapped(uiModel: IAddBuyingItemTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
}

// MARK: - AddBuyingItemDataSourceOutputDelegate
extension AddBuyingItemDataSourceFactory: AddBuyingItemDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
