//
//  CustomerListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.11.2023.
//

import UIKit

protocol CustomerListTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: ICustomerListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(customerId: String)
}


class CustomerListTableViewCell: BaseTableViewCell {
    
    weak var outputDelegate: CustomerListTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnCall: UIButton!
    @IBOutlet private weak var btnArshive: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func registerEvents(uiModel: ICustomerListTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnCall.onTap { [unowned self] _ in
            self.outputDelegate?.phoneNumberTapped(phoneNumber: uiModel.phoneNumber)
        }
        
        btnArshive.onTap { [unowned self] _ in
            self.outputDelegate?.archiveTapped(customerId: uiModel.id ?? "")
        }
    }

    func configureCellWith(uiModel: ICustomerListTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        self.lblName.text = uiModel.name
        self.lblDesc.text = uiModel.desc ?? ""
        self.btnCall.setTitle(uiModel.phoneNumber, for: .normal)
    }
}
