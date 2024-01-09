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
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
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
            self.outputDelegate?.calcActivateTapped(id: uiModel.collectionId ?? "",
                                                    date: uiModel.date,
                                                    isCalc: !uiModel.isCalc)
        }
    }

    func configureCellWith(uiModel: IBuyingCollectionTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.visibilityButtons(isVisible: !uiModel.isCharts)

        btnCalcActivate.backgroundColor = uiModel.isCalc ? .lightGray : uiModel.isActive ? .redColor : .orangeColor
        btnCalcActivate.setTitleColor(.whiteColor, for: .disabled)
        btnCalcActivate.setTitle(uiModel.isCalc ? "Aktif" : uiModel.isActive ? "Aktifleştir" : "Aktifleşmedi", for: .normal)
        btnCalcActivate.isEnabled = !uiModel.isCalc && uiModel.isActive
        btnCalcActivate.roundCornersEachCorner(.allCorners, radius: 6)

        lblDate.text = uiModel.date
        lblWarehouse.text = uiModel.isCharts ? uiModel.totalKg : "Depo Çıkması: \(uiModel.warehouseKg) Kg, \(uiModel.warehouseKgPrice) TL"
        lblTotalKg.text = uiModel.isCharts ? uiModel.totalKgPrice : "Toplam: \(uiModel.totalKg) Kg, \(uiModel.totalKgPrice) TL"
    }

    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
