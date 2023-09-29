//
//  BuyingDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 29.09.2023.
//
import UIKit

protocol BuyingDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IBuyingTableViewCellUIModel)
    func addCollectionTapped(uiModel: IBuyingTableViewCellUIModel)
    func addPaymentTapped(uiModel: IBuyingTableViewCellUIModel)
    func scrollDidScroll(isAvailablePagination: Bool)
    
}

final class BuyingDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: BuyingDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: BuyingDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> BuyingDataSource {

        let dataSource: BuyingDataSource = BuyingDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(BuyingTableViewCell.self, indexPath: indexPath)
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
extension BuyingDataSourceFactory: BuyingTableViewCellOutputDelegate {
    
    func cellTapped(uiModel: IBuyingTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
    
    func addCollectionTapped(uiModel: IBuyingTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
    
    func addPaymentTapped(uiModel: IBuyingTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }
}

// MARK: - BuyingDataSourceOutputDelegate
extension BuyingDataSourceFactory: BuyingDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
