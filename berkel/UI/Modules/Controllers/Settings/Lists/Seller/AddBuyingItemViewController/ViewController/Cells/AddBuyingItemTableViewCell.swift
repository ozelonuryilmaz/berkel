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
    func archiveTapped(sellerId: String)
    func updateTapped(uiModel: IAddBuyingItemTableViewCellUIModel)
}

class AddBuyingItemTableViewCell: BaseTableViewCell {

    weak var outputDelegate: AddBuyingItemTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblTC: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnCall: UIButton!
    @IBOutlet private weak var btnArshive: UIButton!
    @IBOutlet private weak var btnUpdate: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCellWith(uiModel: IAddBuyingItemTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        self.lblName.text = uiModel.name
        self.lblTC.text = uiModel.tc
        self.lblDesc.text = uiModel.desc
        //self.btnCall.setTitle(uiModel.phoneNumber, for: .normal)
    }

    func registerEvents(uiModel: IAddBuyingItemTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnCall.onTap { [unowned self] _ in
            self.outputDelegate?.phoneNumberTapped(phoneNumber: uiModel.phoneNumber)
        }

        btnArshive.onTap { [unowned self] _ in
            self.outputDelegate?.archiveTapped(sellerId: uiModel.id)
        }

        btnUpdate.onTap { [unowned self] _ in
            self.outputDelegate?.updateTapped(uiModel: uiModel)
        }
    }

}
