//
//  StockDetailInfoDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//

import UIKit

protocol StockDetailInfoDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IStockDetailInfoTableViewCellUIModel)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class StockDetailInfoDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: StockDetailInfoDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: StockDetailInfoDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> StockDetailInfoDataSource {

        let dataSource: StockDetailInfoDataSource = StockDetailInfoDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(StockDetailInfoTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - StockDetailInfoTableViewCellOutputDelegate
extension StockDetailInfoDataSourceFactory: StockDetailInfoTableViewCellOutputDelegate {

    func cellTapped(uiModel: IStockDetailInfoTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
}

// MARK: - StockDetailInfoDataSourceOutputDelegate
extension StockDetailInfoDataSourceFactory: StockDetailInfoDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
