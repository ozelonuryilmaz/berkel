//
//  MyStockListItemCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.03.2024.
//

import UIKit

class MyStockListItemCell: BaseTableViewCell {

    @IBOutlet private weak var labelName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with uiModel: MyStockListItemCellUIModel) {
        registerEvents(uiModel: uiModel)

        labelName.text = uiModel.subStockName
    }

    private func registerEvents(uiModel: MyStockListItemCellUIModel) {
        
    }
    
}
