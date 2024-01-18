//
//  SellerDetailPaymentTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import UIKit

protocol SellerDetailPaymentTableViewCellOutputDelegate: AnyObject {
    func deleteButtonTapped(uiModel: SellerPaymentModel)
}

class SellerDetailPaymentTableViewCell: BaseTableViewCell {

    weak var outputDelegate: SellerDetailPaymentTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: ISellerDetailPaymentTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        lblDate.text = uiModel.payment.date?.dateFormatToAppDisplayType() ?? ""
        lblPrice.text = "\(uiModel.payment.payment.decimalString()) TL Ödendi"
        lblDesc.text = uiModel.payment.description ?? ""
    }
    
    func registerEvents(uiModel: ISellerDetailPaymentTableViewCellUIModel) {

        // Events
        btnDelete.onTap { [unowned self] _ in
            self.outputDelegate?.deleteButtonTapped(uiModel: uiModel.payment)
        }
    }
}
