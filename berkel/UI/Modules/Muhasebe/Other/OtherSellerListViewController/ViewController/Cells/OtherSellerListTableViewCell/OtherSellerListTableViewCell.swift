//
//  OtherSellerListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

protocol OtherSellerListTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOtherSellerListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(otherSellerId: String)
    func updateTapped(uiModel: IOtherSellerListTableViewCellUIModel)
}

class OtherSellerListTableViewCell: BaseTableViewCell {

    weak var outputDelegate: OtherSellerListTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnCall: UIButton!
    @IBOutlet private weak var btnArshive: UIButton!
    @IBOutlet private weak var btnUpdate: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCellWith(uiModel: IOtherSellerListTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        self.lblName.text = "\(uiModel.name) (\(uiModel.categoryName ?? ""))"
        self.lblDesc.text = uiModel.desc ?? ""
        //self.btnCall.setTitle(uiModel.phoneNumber, for: .normal)
    }

    func registerEvents(uiModel: IOtherSellerListTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnCall.onTap { [unowned self] _ in
            self.outputDelegate?.phoneNumberTapped(phoneNumber: uiModel.phoneNumber)
        }

        btnArshive.onTap { [unowned self] _ in
            self.outputDelegate?.archiveTapped(otherSellerId: uiModel.id ?? "")
        }

        btnUpdate.onTap { [unowned self] _ in
            self.outputDelegate?.updateTapped(uiModel: uiModel)
        }
    }
}
