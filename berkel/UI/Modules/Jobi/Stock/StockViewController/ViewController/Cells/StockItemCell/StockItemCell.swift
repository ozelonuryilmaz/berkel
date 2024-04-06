//
//  StockItemCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.04.2024.
//

import UIKit

class StockItemCell: BaseTableViewCell {

    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with uiModel: StockItemCellUIModel) {
        registerEvents(uiModel: uiModel)

        labelName.text = uiModel.subStockName
        labelCount.text = uiModel.subStockCount
    }

    private func registerEvents(uiModel: StockItemCellUIModel) {

    }
}
