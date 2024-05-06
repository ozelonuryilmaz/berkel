//
//  OrderDetailPaymentTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import UIKit

protocol OrderDetailPaymentTableViewCellOutputDelegate: AnyObject {
    func deleteButtonTapped(uiModel: OrderPaymentModel)
}

class OrderDetailPaymentTableViewCell: BaseTableViewCell {
    
    weak var outputDelegate: OrderDetailPaymentTableViewCellOutputDelegate? = nil
    
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: IOrderDetailPaymentTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.btnDelete.isEnabled = uiModel.isActive

        lblDate.text = uiModel.payment.date?.dateFormatToAppDisplayType() ?? ""
        lblPrice.text = "\(uiModel.payment.payment.decimalString()) TL Tahsilat"
        lblDesc.text = uiModel.payment.description ?? ""
    }
    
    func registerEvents(uiModel: IOrderDetailPaymentTableViewCellUIModel) {

        // Events
        btnDelete.onTap { [unowned self] _ in
            self.outputDelegate?.deleteButtonTapped(uiModel: uiModel.payment)
        }
    }
}
