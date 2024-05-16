//
//  OrderDetailCollectionTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import UIKit

protocol OrderDetailCollectionTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
    func appendFaturaTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
    func appendCopyFaturaTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
    func cancelTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
}


class OrderDetailCollectionTableViewCell: BaseTableViewCell {

    weak var outputDelegate: OrderDetailCollectionTableViewCellOutputDelegate? = nil

    // MARK: Outlets
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblProductName: UILabel!
    @IBOutlet private weak var lblCount: UILabel!
    @IBOutlet private weak var btnFatura: UIButton!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var btnCopyFatura: UIButton!
    @IBOutlet private weak var viewButtons: UIView!

    // MARK: Constraints Outlets
    @IBOutlet private weak var constraintViewButtonsHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
        btnFatura.roundCornersEachCorner(.allCorners, radius: 6)
        btnCancel.roundCornersEachCorner(.allCorners, radius: 6)
    }

    func registerEvents(uiModel: IOrderDetailCollectionTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnCancel.onTap { [unowned self] _ in
            self.outputDelegate?.cancelTapped(uiModel: uiModel)
        }

        btnFatura.onTap { [unowned self] _ in
            self.outputDelegate?.appendFaturaTapped(uiModel: uiModel)
        }

        btnCopyFatura.onTap { [unowned self] _ in
            guard false == uiModel.orderCollectionModel?.faturaNo?.isEmpty else { return }
            self.outputDelegate?.appendCopyFaturaTapped(uiModel: uiModel)
        }
    }

    func configureCellWith(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        registerEvents(uiModel: uiModel)
        visibilityButtons(isVisible: uiModel.isActive)

        lblDate.text = uiModel.date
        lblProductName.text = uiModel.orderName
        lblCount.text = uiModel.count

        btnCopyFatura.setTitle(uiModel.orderCollectionModel?.faturaNo ?? "", for: .normal)
        btnCopyFatura.setTitleColor(.primaryBlue, for: .normal)
    }

    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
