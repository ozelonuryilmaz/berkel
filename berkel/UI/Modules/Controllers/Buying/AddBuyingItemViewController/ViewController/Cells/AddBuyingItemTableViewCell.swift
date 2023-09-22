//
//  AddBuyingItemTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.09.2023.
//

import UIKit

protocol AddBuyingItemTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IAddBuyingItemTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
}

class AddBuyingItemTableViewCell: BaseTableViewCell {

    weak var outputDelegate: AddBuyingItemTableViewCellOutputDelegate? = nil
    
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblTC: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnCall: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func registerEvents(uiModel: IAddBuyingItemTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnCall.onTap { [unowned self] _ in
            self.outputDelegate?.phoneNumberTapped(phoneNumber: uiModel.phoneNumber)
        }
    }

    func configureCellWith(uiModel: IAddBuyingItemTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        self.lblName.text = uiModel.name
        self.lblTC.text = uiModel.tc
        self.lblDesc.text = uiModel.desc
        self.btnCall.setTitle(uiModel.phoneNumber, for: .normal)
    }
}
