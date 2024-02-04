//
//  OtherDetailPaymentTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.02.2024.
//

import UIKit

protocol OtherDetailPaymentTableViewCellOutputDelegate: AnyObject {
    func deleteButtonTapped(uiModel: OtherPaymentModel)
}

class OtherDetailPaymentTableViewCell: BaseTableViewCell {
    
    weak var outputDelegate: OtherDetailPaymentTableViewCellOutputDelegate? = nil
    
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: IOtherDetailPaymentTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        lblDate.text = uiModel.payment.date?.dateFormatToAppDisplayType() ?? ""
        lblPrice.text = "\(uiModel.payment.payment.decimalString()) TL Ödendi"
        lblDesc.text = uiModel.payment.description ?? ""
    }
    
    func registerEvents(uiModel: IOtherDetailPaymentTableViewCellUIModel) {

        // Events
        btnDelete.onTap { [unowned self] _ in
            self.outputDelegate?.deleteButtonTapped(uiModel: uiModel.payment)
        }
    }
}
