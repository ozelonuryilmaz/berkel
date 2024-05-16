//
//  OrderDetailCollectionDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import UIKit

protocol OrderDetailCollectionDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
    func appendFaturaTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
    func appendCopyFaturaTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
    func cancelTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
}

final class OrderDetailCollectionDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: OrderDetailCollectionDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: OrderDetailCollectionDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> OrderDetailCollectionDataSource {

        let dataSource: OrderDetailCollectionDataSource = OrderDetailCollectionDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(OrderDetailCollectionTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension OrderDetailCollectionDataSourceFactory: OrderDetailCollectionTableViewCellOutputDelegate {

    func cellTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }

    func appendFaturaTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        self.outputDelegate?.appendFaturaTapped(uiModel: uiModel)
    }
    
    func appendCopyFaturaTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        self.outputDelegate?.appendCopyFaturaTapped(uiModel: uiModel)
    }

    func cancelTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        self.outputDelegate?.cancelTapped(uiModel: uiModel)
    }
}

// MARK: - OrderDetailCollectionDataSourceOutputDelegate
extension OrderDetailCollectionDataSourceFactory: OrderDetailCollectionDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        //self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
