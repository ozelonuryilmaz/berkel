//
//  BuyingPaymentTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.10.2023.
//

import UIKit

protocol BuyingPaymentTableViewCellOutputDelegate: AnyObject {
    func deleteButtonTapped(uiModel: NewBuyingPaymentModel)
}

class BuyingPaymentTableViewCell: BaseTableViewCell {

    weak var outputDelegate: BuyingPaymentTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: IBuyingPaymentTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.btnDelete.isEnabled = uiModel.isActive

        lblDate.text = uiModel.payment.date?.dateFormatToAppDisplayType() ?? ""
        lblPrice.text = "\(uiModel.payment.payment.decimalString()) TL Ödendi"
        lblDesc.text = uiModel.payment.description ?? ""
    }

    func registerEvents(uiModel: IBuyingPaymentTableViewCellUIModel) {

        // Events
        btnDelete.onTap { [unowned self] _ in
            self.outputDelegate?.deleteButtonTapped(uiModel: uiModel.payment)
        }
    }
}
