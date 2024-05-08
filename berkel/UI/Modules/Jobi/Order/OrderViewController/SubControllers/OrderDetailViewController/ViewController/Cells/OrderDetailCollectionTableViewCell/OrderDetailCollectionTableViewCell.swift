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
    }

    func configureCellWith(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        registerEvents(uiModel: uiModel)
        visibilityButtons(isVisible: uiModel.isVisibleButtons)

        lblDate.text = uiModel.date
        lblProductName.text = uiModel.orderName
        lblCount.text = uiModel.count
    }

    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
