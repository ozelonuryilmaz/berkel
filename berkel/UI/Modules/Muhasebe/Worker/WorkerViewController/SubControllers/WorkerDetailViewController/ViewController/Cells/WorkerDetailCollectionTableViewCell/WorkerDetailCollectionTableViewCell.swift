//
//  WorkerDetailCollectionTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.11.2023.
//

import UIKit

protocol WorkerDetailCollectionTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IWorkerDetailCollectionTableViewCellUIModel)
    func calcActivateTapped(id: String, date: String, isCalc: Bool)
}

class WorkerDetailCollectionTableViewCell: BaseTableViewCell {

    weak var outputDelegate: WorkerDetailCollectionTableViewCellOutputDelegate? = nil

    // MARK: Outlets
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblTotalPrice: UILabel!
    @IBOutlet private weak var lblWorker: UILabel!
    @IBOutlet private weak var btnCalcActivate: UIButton!
    @IBOutlet private weak var viewButtons: UIView!

    // MARK: Constraints Outlets
    @IBOutlet private weak var constraintViewButtonsHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func registerEvents(uiModel: IWorkerDetailCollectionTableViewCellUIModel) {

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

    func configureCellWith(uiModel: IWorkerDetailCollectionTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
        self.visibilityButtons(isVisible: !uiModel.isCharts)

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
        lblWorker.text = uiModel.gardenOwner
        lblTotalPrice.text = uiModel.isCharts ? "\(uiModel.totalPrice)" : "Toplam: \(uiModel.totalPrice) TL"
    }

    private func visibilityButtons(isVisible: Bool) {
        constraintViewButtonsHeight.constant = isVisible ? 52 : 0
        constraintViewButtonsHeight.priority = isVisible ? .defaultHigh : .required
        viewButtons.isHidden = !isVisible
    }
}
