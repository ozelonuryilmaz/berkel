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

        btnCalcActivate.backgroundColor = uiModel.isCalc ? .lightGray : uiModel.isActive ? .redColor : .orangeColor
        btnCalcActivate.setTitleColor(.whiteColor, for: .disabled)
        btnCalcActivate.setTitle(uiModel.isCalc ? "Aktif" : uiModel.isActive ? "Aktifleştir" : "Aktifleşmedi", for: .normal)
        btnCalcActivate.isEnabled = !uiModel.isCalc && uiModel.isActive
        btnCalcActivate.roundCornersEachCorner(.allCorners, radius: 6)

        lblDate.text = uiModel.date
        lblFaturaNo.text = "Fatura No: \(uiModel.faturaNo)"
        lblTotalPrice.text = "\(uiModel.totalKg) Kg, \(uiModel.totalPrice) TL"
    }
}
