//
//  WorkerDetailPaymentTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import UIKit

class WorkerDetailPaymentTableViewCell: BaseTableViewCell {
    
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }
    
    func configureCell(with uiModel: IWorkerDetailPaymentTableViewCellUIModel) {
        lblDate.text = uiModel.payment.date?.dateFormatToAppDisplayType() ?? ""
        lblPrice.text = "\(uiModel.payment.payment.decimalString()) TL Ödendi"
        lblDesc.text = uiModel.payment.description ?? ""
    }
}
