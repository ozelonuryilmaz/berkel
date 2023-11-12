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

        btnCalcActivate.backgroundColor = uiModel.isCalc ? .lightGray : uiModel.isActive ? .redColor : .orangeColor
        btnCalcActivate.setTitleColor(.whiteColor, for: .disabled)
        btnCalcActivate.setTitle(uiModel.isCalc ? "Aktif" : uiModel.isActive ? "Aktifleştir" : "Aktifleşmedi", for: .normal)
        btnCalcActivate.isEnabled = !uiModel.isCalc && uiModel.isActive
        btnCalcActivate.roundCornersEachCorner(.allCorners, radius: 6)

        lblDate.text = uiModel.date
        lblWorker.text = "\(uiModel.kesiciCount) Kesici, \(uiModel.ayakciCount) Ayakçı, ..."
        lblTotalPrice.text = "Toplam: \(uiModel.totalPrice) TL"
    }
}
