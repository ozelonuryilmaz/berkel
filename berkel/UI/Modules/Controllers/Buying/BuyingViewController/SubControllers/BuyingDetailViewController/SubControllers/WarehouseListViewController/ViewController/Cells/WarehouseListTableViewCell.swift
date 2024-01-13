//
//  WarehouseListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 19.10.2023.
//

import UIKit

class WarehouseListTableViewCell: BaseTableViewCell {

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblKg: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblResult: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: IWarehouseListTableViewCellUIModelUIModel) {
        lblDate.text = uiModel.warehouses.date?.dateFormatToAppDisplayType() ?? ""
        lblKg.text = "Depo çıkması: \(uiModel.warehouses.wavehouseKg.decimalString()) Kg"
        lblPrice.text = "Kg fiyatı: \(uiModel.warehouses.wavehousePrice.decimalString()) TL"
        lblResult.text = "Tutar: \(uiModel.result.decimalString()) TL"
        lblDesc.text = uiModel.warehouses.description ?? ""
    }
}
