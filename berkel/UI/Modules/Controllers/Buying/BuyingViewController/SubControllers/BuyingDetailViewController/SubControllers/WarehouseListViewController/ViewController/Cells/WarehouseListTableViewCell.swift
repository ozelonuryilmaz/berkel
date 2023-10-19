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
        let kg = uiModel.warehouses.wavehouseKg.decimalString()
        let price = uiModel.warehouses.wavehousePrice.decimalString()
        let result = (Int(kg) ?? 0) * (Int(price) ?? 0)
        
        lblDate.text = uiModel.warehouses.date?.dateFormatToAppDisplayType() ?? ""
        lblKg.text = "Depo çıkması: \(kg) Kg"
        lblPrice.text = "Kg fiyatı: \(price) TL"
        lblResult.text = "Tutar: \(result) TL"
        lblDesc.text = uiModel.warehouses.description ?? ""
    }
}
