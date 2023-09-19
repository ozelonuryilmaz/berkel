//
//  AddBuyingItemTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol AddBuyingItemTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IAddBuyingItemTableViewCellUIModel)
}

class AddBuyingItemTableViewCell: BaseTableViewCell {

    weak var outputDelegate: AddBuyingItemTableViewCellOutputDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func registerEvents(uiModel: IAddBuyingItemTableViewCellUIModel) {

        // Events
        // mContentView.onTap { [unowned self] _ in self.outputDelegate?.cellTapped(uiModel: uiModel) }
    }

    func configureCellWith(uiModel: IAddBuyingItemTableViewCellUIModel) {
        registerEvents(uiModel: uiModel)

    }
}
