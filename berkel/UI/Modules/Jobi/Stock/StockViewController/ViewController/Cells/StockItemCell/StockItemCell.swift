//
//  StockItemCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.04.2024.
//

import UIKit

protocol StockItemCellOutputDelegate: AnyObject {

    func subStockTapped(subStock: SubStockModel)
}

class StockItemCell: BaseTableViewCell {

    @IBOutlet private weak var iconArrowRight: UIImageView!
    @IBOutlet private weak var mContentView: UIView!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelCount: UILabel!
    
    weak var outputDelegate: StockItemCellOutputDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with uiModel: StockItemCellUIModel, isArrowIconHidden: Bool = false) {
        registerEvents(uiModel: uiModel)

        labelName.text = uiModel.subStockName
        labelCount.text = uiModel.subStockCount
        iconArrowRight.isHidden = isArrowIconHidden
    }

    private func registerEvents(uiModel: StockItemCellUIModel) {

        self.mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.subStockTapped(subStock: uiModel.subStock)
        }
    }
}
