//
//  SellerDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 23.11.2023.
//

import UIKit

protocol SellerDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: ISellerTableViewCellUIModel)
    func addCollectionTapped(uiModel: ISellerTableViewCellUIModel)
    func addPaymentTapped(uiModel: ISellerTableViewCellUIModel)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class SellerDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: SellerDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: SellerDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> SellerDataSource {

        let dataSource: SellerDataSource = SellerDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(SellerTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension SellerDataSourceFactory: SellerTableViewCellOutputDelegate {
    
    func cellTapped(uiModel: ISellerTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
    
    func addCollectionTapped(uiModel: ISellerTableViewCellUIModel) {
        self.outputDelegate?.addCollectionTapped(uiModel: uiModel)
    }
    
    func addPaymentTapped(uiModel: ISellerTableViewCellUIModel) {
        self.outputDelegate?.addPaymentTapped(uiModel: uiModel)
    }
}

// MARK: - SellerDataSourceOutputDelegate
extension SellerDataSourceFactory: SellerDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
