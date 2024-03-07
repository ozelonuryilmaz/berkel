//
//  SellerDetailCollectionDataSourceFactory.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import UIKit

protocol SellerDetailCollectionDataSourceFactoryOutputDelegate: AnyObject {
    func cellTapped(uiModel: ISellerDetailCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
}

final class SellerDetailCollectionDataSourceFactory {

    private let tableView: UITableView
    private weak var outputDelegate: SellerDetailCollectionDataSourceFactoryOutputDelegate?

    init(tableView: UITableView,
         outputDelegate: SellerDetailCollectionDataSourceFactoryOutputDelegate?) {
        self.tableView = tableView
        self.outputDelegate = outputDelegate
    }

    func makeDataSource() -> SellerDetailCollectionDataSource {

        let dataSource: SellerDetailCollectionDataSource = SellerDetailCollectionDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in

            let cell = tableView.generateReusableCell(SellerDetailCollectionTableViewCell.self, indexPath: indexPath)
            cell.configureCellWith(uiModel: itemIdentifier.uiModel)
            cell.outputDelegate = self

            return cell
        }

        dataSource.outputDelegate = self
        return dataSource
    }
}

// MARK: - PhotoSelectionCollectionViewCellOutputDelegate
extension SellerDetailCollectionDataSourceFactory: SellerDetailCollectionTableViewCellOutputDelegate {

    func cellTapped(uiModel: ISellerDetailCollectionTableViewCellUIModel) {
        self.outputDelegate?.cellTapped(uiModel: uiModel)
    }

    func calcActivateTapped(id: String, date: String, isCalc: Bool) {
        self.outputDelegate?.calcActivateTapped(id: id, date: date, isCalc: isCalc)
    }
}

// MARK: - SellerDetailCollectionDataSourceOutputDelegate
extension SellerDetailCollectionDataSourceFactory: SellerDetailCollectionDataSourceOutputDelegate {

    func scrollDidScroll(_ scrollView: UIScrollView) {
        //self.outputDelegate?.scrollDidScroll(isAvailablePagination: scrollView.isAvailablePagination)
    }
}
