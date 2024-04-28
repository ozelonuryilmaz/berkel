//
//  OrderDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.04.2024.
//

import UIKit

protocol OrderDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOrderTableViewCellUIModel)
    func addCollectionTapped(uiModel: IOrderTableViewCellUIModel)
    func addPaymentTapped(uiModel: IOrderTableViewCellUIModel)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class OrderDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: OrderDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: OrderDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> OrderDataSource {

        let dataSource: OrderDataSource = OrderDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(OrderTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension OrderDataSourceFactory: OrderTableViewCellOutputDelegate {
    
    func cellTapped(uiModel: IOrderTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
    
    func addCollectionTapped(uiModel: IOrderTableViewCellUIModel) {
        self.outputDelegate?.addCollectionTapped(uiModel: uiModel)
    }
    
    func addPaymentTapped(uiModel: IOrderTableViewCellUIModel) {
        self.outputDelegate?.addPaymentTapped(uiModel: uiModel)
    }
}

// MARK: - OrderDataSourceOutputDelegate
extension OrderDataSourceFactory: OrderDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
