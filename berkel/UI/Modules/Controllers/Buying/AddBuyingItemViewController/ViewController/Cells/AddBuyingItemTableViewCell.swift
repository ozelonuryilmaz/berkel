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
    
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var mContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func registerEvents(uiModel: IAddBuyingItemTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }
    }

    func configureCellWith(uiModel: IAddBuyingItemTableViewCellUIModel) {
        registerEvents(uiModel: uiModel)

        self.lblName.text = uiModel.name
    }
}
