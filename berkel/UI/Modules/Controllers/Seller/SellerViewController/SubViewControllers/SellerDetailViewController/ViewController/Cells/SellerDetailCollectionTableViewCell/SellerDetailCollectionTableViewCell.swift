//
//  SellerDetailCollectionTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 3.12.2023.
//

import UIKit

protocol SellerDetailCollectionTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: ISellerDetailCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
}

class SellerDetailCollectionTableViewCell: BaseTableViewCell {

    weak var outputDelegate: SellerDetailCollectionTableViewCellOutputDelegate? = nil

    // MARK: Outlets
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblFaturaNo: UILabel!
    @IBOutlet private weak var lblTotalPrice: UILabel!
    @IBOutlet private weak var btnCalcActivate: UIButton!
    @IBOutlet private weak var viewButtons: UIView!

    // MARK: Constraints Outlets
    @IBOutlet private weak var constraintViewButtonsHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func registerEvents(uiModel: ISellerDetailCollectionTableViewCellUIModel) {

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
    
    func configureCellWith(uiModel: ISellerDetailCollectionTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.visibilityButtons(isVisible: uiModel.isVisibleButtons)
        
        let isCalc = !uiModel.isActive && uiModel.isCalc
        let isntCalc = !uiModel.isActive && !uiModel.isCalc
        let btnTitle: String = isCalc ? "Aktif" : isntCalc ? "Pasif" : (uiModel.isCalc ? "Pasifleştir" : "Aktifleştir")
        let bgColor: UIColor = (isCalc || isntCalc) ? .lightGray : (uiModel.isCalc ? .redColor : .orangeColor)

        btnCalcActivate.roundCornersEachCorner(.allCorners, radius: 6)
        btnCalcActivate.setTitleColor(.whiteColor, for: .disabled)
        btnCalcActivate.setTitle(btnTitle, for: .normal)
        btnCalcActivate.isEnabled = uiModel.isActive
        btnCalcActivate.backgroundColor = bgColor

        lblDate.text = uiModel.date
        lblFaturaNo.text = uiModel.chartTotalKg == nil ? "Fatura No: \(uiModel.faturaNo)" : uiModel.chartTotalKg ?? ""
        lblTotalPrice.text = uiModel.chartTotalPrice == nil ? "\(uiModel.totalKg) Kg, \(uiModel.totalPrice) TL" : uiModel.chartTotalPrice ?? ""
    }
    
    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
