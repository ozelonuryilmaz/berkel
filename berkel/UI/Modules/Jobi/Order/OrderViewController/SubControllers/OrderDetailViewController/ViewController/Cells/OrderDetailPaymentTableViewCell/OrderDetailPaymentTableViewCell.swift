//
//  OrderDetailPaymentTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import UIKit

protocol OrderDetailPaymentTableViewCellOutputDelegate: AnyObject {
    func deleteButtonTapped(uiModel: OrderPaymentModel)
    func faturaButtonTapped(uiModel: OrderPaymentModel)
    func copyFaturaButtonTapped(uiModel: OrderPaymentModel)
}

class OrderDetailPaymentTableViewCell: BaseTableViewCell {

    weak var outputDelegate: OrderDetailPaymentTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnDelete: UIButton!
    @IBOutlet private weak var btnFatura: UIButton!
    @IBOutlet private weak var btnCopyFatura: UIButton!
    @IBOutlet private weak var viewButtons: UIView!

    // MARK: Constraints Outlets
    @IBOutlet private weak var constraintViewButtonsHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
        btnFatura.roundCornersEachCorner(.allCorners, radius: 6)
        btnDelete.roundCornersEachCorner(.allCorners, radius: 6)
    }

    func configureCell(with uiModel: IOrderDetailPaymentTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.visibilityButtons(isVisible: uiModel.isActive)

        lblDate.text = uiModel.payment.date?.dateFormatToAppDisplayType() ?? ""
        lblPrice.text = "\(uiModel.payment.payment.decimalString()) TL Tahsilat"
        lblDesc.text = uiModel.payment.description ?? ""

        btnCopyFatura.setTitle(uiModel.payment.faturaNo ?? "", for: .normal)
        btnCopyFatura.setTitleColor(.primaryBlue, for: .normal)
    }

    func registerEvents(uiModel: IOrderDetailPaymentTableViewCellUIModel) {

        // Events
        btnDelete.onTap { [unowned self] _ in
            self.outputDelegate?.deleteButtonTapped(uiModel: uiModel.payment)
        }

        btnFatura.onTap { [unowned self] _ in
            self.outputDelegate?.faturaButtonTapped(uiModel: uiModel.payment)
        }

        btnCopyFatura.onTap { [unowned self] _ in
            guard false == uiModel.payment.faturaNo?.isEmpty else { return }
            self.outputDelegate?.copyFaturaButtonTapped(uiModel: uiModel.payment)
        }
    }

    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
