//
//  BuyingCollectionTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 16.10.2023.
//

import UIKit

protocol BuyingCollectionTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IBuyingCollectionTableViewCellUIModel)
    func warehouseTapped(uiModel: IBuyingCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String?)
}

class BuyingCollectionTableViewCell: BaseTableViewCell {

    weak var outputDelegate: BuyingCollectionTableViewCellOutputDelegate? = nil

    // MARK: Outlets
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblTotalKg: UILabel!
    @IBOutlet private weak var lblWarehouse: UILabel!
    @IBOutlet private weak var btnWarehouse: UIButton!
    @IBOutlet private weak var btnCalcActivate: UIButton!
    @IBOutlet private weak var viewButtons: UIView!

    
    // MARK: Constraints Outlets
    @IBOutlet private weak var constraintViewButtonsHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func registerEvents(uiModel: IBuyingCollectionTableViewCellUIModel) {
        
        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnWarehouse.onTap { [unowned self] _ in
            self.outputDelegate?.warehouseTapped(uiModel: uiModel)
        }
        
        btnCalcActivate.onTap { [unowned self] _ in
            self.outputDelegate?.calcActivateTapped(id: uiModel.buyingId)
        }
    }

    func configureCellWith(uiModel: IBuyingCollectionTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.visibilityButtons(isVisible: uiModel.isActive)
        
        btnCalcActivate.backgroundColor = uiModel.isCalc ? .lightGray : .redColor
        btnCalcActivate.setTitleColor(.whiteColor, for: .disabled)
        btnCalcActivate.setTitle(uiModel.isCalc ? "Aktif" : "Aktifleştir", for: .normal)
        btnCalcActivate.isEnabled = !uiModel.isCalc
        btnCalcActivate.roundCornersEachCorner(.allCorners, radius: 6)
        
        lblDate.text = uiModel.date
        lblTotalKg.text = "Net Toplam: \(uiModel.totalKg) Kg"
        lblWarehouse.text = "Depo Çıkması: \(uiModel.warehouseKg) Kg"
    }

    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
