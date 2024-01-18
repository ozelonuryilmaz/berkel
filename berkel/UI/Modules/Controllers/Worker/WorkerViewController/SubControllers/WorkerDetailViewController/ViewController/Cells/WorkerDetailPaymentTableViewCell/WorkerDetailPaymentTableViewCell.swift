//
//  WorkerDetailPaymentTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import UIKit

protocol WorkerDetailPaymentTableViewCellOutputDelegate: AnyObject {
    func deleteButtonTapped(uiModel: WorkerPaymentModel)
}

class WorkerDetailPaymentTableViewCell: BaseTableViewCell {

    weak var outputDelegate: WorkerDetailPaymentTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: IWorkerDetailPaymentTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        lblDate.text = uiModel.payment.date?.dateFormatToAppDisplayType() ?? ""
        lblPrice.text = "\(uiModel.payment.payment.decimalString()) TL Ödendi"
        lblDesc.text = uiModel.payment.description ?? ""
    }

    func registerEvents(uiModel: IWorkerDetailPaymentTableViewCellUIModel) {

        // Events
        btnDelete.onTap { [unowned self] _ in
            self.outputDelegate?.deleteButtonTapped(uiModel: uiModel.payment)
        }
    }
}
