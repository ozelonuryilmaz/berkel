//
//  OtherDetailCollectionTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 4.02.2024.
//

import UIKit

protocol OtherDetailCollectionTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IOtherDetailCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
}


class OtherDetailCollectionTableViewCell: BaseTableViewCell {

    weak var outputDelegate: OtherDetailCollectionTableViewCellOutputDelegate? = nil

    // MARK: Outlets
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblTotalPrice: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnCalcActivate: UIButton!
    @IBOutlet private weak var viewButtons: UIView!

    // MARK: Constraints Outlets
    @IBOutlet private weak var constraintViewButtonsHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func registerEvents(uiModel: IOtherDetailCollectionTableViewCellUIModel) {

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
    
    func configureCellWith(uiModel: IOtherDetailCollectionTableViewCellUIModel) {
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
        lblTotalPrice.text = uiModel.price + " TL"
        lblDesc.text = uiModel.desc
    }
    
    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
