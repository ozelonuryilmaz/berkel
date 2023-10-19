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
        let kg = uiModel.warehouses.wavehouseKg
        let price = uiModel.warehouses.wavehousePrice
        let result = (Double(kg) * Double(price))

        lblDate.text = uiModel.warehouses.date?.dateFormatToAppDisplayType() ?? ""
        lblKg.text = "Depo çıkması: \(kg.decimalString()) Kg"
        lblPrice.text = "Kg fiyatı: \(price.decimalString()) TL"
        lblResult.text = "Tutar: \(result.decimalString()) TL"
        lblDesc.text = uiModel.warehouses.description ?? ""
    }
}
