//
//  BuyingCollectionDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol BuyingCollectionDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: IBuyingCollectionTableViewCellUIModel)
    func warehouseTapped(uiModel: IBuyingCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
    func scrollDidScroll(isAvailablePagination: Bool)
}

final class BuyingCollectionDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: BuyingCollectionDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: BuyingCollectionDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> BuyingCollectionDataSource {

        let dataSource: BuyingCollectionDataSource = BuyingCollectionDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(BuyingCollectionTableViewCell.self, indexPath: indexPath)
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
extension BuyingCollectionDataSourceFactory: BuyingCollectionTableViewCellOutputDelegate {

    func cellTapped(uiModel: IBuyingCollectionTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }

    func warehouseTapped(uiModel: IBuyingCollectionTableViewCellUIModel) {
        self.outputDelegate?.warehouseTapped(uiModel: uiModel)
    }

    func calcActivateTapped(id: String, date: String, isCalc: Bool) {
        self.outputDelegate?.calcActivateTapped(id: id, date: date, isCalc: isCalc)
    }
}

// MARK: - BuyingCollectionDataSourceOutputDelegate
extension BuyingCollectionDataSourceFactory: BuyingCollectionDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
