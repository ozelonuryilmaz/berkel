//
//  JBCustomerListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.04.2024.
//

import UIKit

protocol JBCustomerListTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IJBCustomerListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(customerId: String)
    func updateTapped(uiModel: IJBCustomerListTableViewCellUIModel)
    func priceTapped(uiModel: IJBCustomerListTableViewCellUIModel)
    func pastTapped(uiModel: IJBCustomerListTableViewCellUIModel)
}


class JBCustomerListTableViewCell: BaseTableViewCell {

    weak var outputDelegate: JBCustomerListTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnPrice: UIButton!
    @IBOutlet private weak var btnCall: UIButton!
    @IBOutlet private weak var btnArshive: UIButton!
    @IBOutlet private weak var btnUpdate: UIButton!
    @IBOutlet private weak var btnPast: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCellWith(uiModel: IJBCustomerListTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        self.lblName.text = uiModel.name
        self.lblDesc.text = uiModel.desc ?? ""
        //self.btnCall.setTitle(uiModel.phoneNumber, for: .normal)
    }

    func registerEvents(uiModel: IJBCustomerListTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }
        
        btnPrice.onTap { [unowned self] _ in
            self.outputDelegate?.priceTapped(uiModel: uiModel)
        }

        btnCall.onTap { [unowned self] _ in
            self.outputDelegate?.phoneNumberTapped(phoneNumber: uiModel.phoneNumber)
        }

        btnArshive.onTap { [unowned self] _ in
            self.outputDelegate?.archiveTapped(customerId: uiModel.id ?? "")
        }

        btnUpdate.onTap { [unowned self] _ in
            self.outputDelegate?.updateTapped(uiModel: uiModel)
        }
        
        btnPast.onTap { [unowned self] _ in
            self.outputDelegate?.pastTapped(uiModel: uiModel)
        }
    }

}
