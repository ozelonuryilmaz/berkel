//
//  OrderDetailCollectionTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 6.05.2024.
//

import UIKit

protocol OrderDetailCollectionTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOrderDetailCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
}


class OrderDetailCollectionTableViewCell: BaseTableViewCell {

    weak var outputDelegate: OrderDetailCollectionTableViewCellOutputDelegate? = nil

    // MARK: Outlets
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblProductName: UILabel!
    @IBOutlet private weak var lblCount: UILabel!
    @IBOutlet private weak var btnCalcActivate: UIButton!
    @IBOutlet private weak var viewButtons: UIView!

    // MARK: Constraints Outlets
    @IBOutlet private weak var constraintViewButtonsHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func registerEvents(uiModel: IOrderDetailCollectionTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnCalcActivate.onTap { [unowned self] _ in
            self.outputDelegate?.calcActivateTapped(id: uiModel.collectionId ?? "",
                                                    date: uiModel.date,
                                                    isCalc: !uiModel.isCalc)
        }
    }

    func configureCellWith(uiModel: IOrderDetailCollectionTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.visibilityButtons(isVisible: uiModel.isVisibleButtons)

        let isCalc = !uiModel.isActive && uiModel.isCalc
        let isntCalc = !uiModel.isActive && !uiModel.isCalc
        let btnTitle: String = isCalc ? "Aktif" : isntCalc ? "Pasif" : (uiModel.isCalc ? "Pasifleştir" : "Aktifleştir")
        let bgColor: UIColor = (isCalc || isntCalc) ? .lightGray : (uiModel.isCalc ? .lightGray : .orangeColor)

        btnCalcActivate.roundCornersEachCorner(.allCorners, radius: 6)
        btnCalcActivate.setTitleColor(.whiteColor, for: .disabled)
        btnCalcActivate.setTitle(btnTitle, for: .normal)
        btnCalcActivate.isEnabled = uiModel.isActive
        btnCalcActivate.backgroundColor = bgColor
        mContentView.alpha = uiModel.isCalc ? 1 : 0.4

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
