//
//  StockDetailInfoTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 7.04.2024.
//

import UIKit

protocol StockDetailInfoTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: IStockDetailInfoTableViewCellUIModel)
}

class StockDetailInfoTableViewCell: BaseTableViewCell {

    weak var outputDelegate: StockDetailInfoTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var lblActive: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
        lblActive.roundCornersEachCorner(.allCorners, radius: 6)
    }

    func configureCellWith(uiModel: IStockDetailInfoTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)
    
        self.lblName.text = "\(uiModel.count) Adet / \(uiModel.date)"
        self.lblDesc.text = uiModel.desc
        self.lblActive.backgroundColor = uiModel.type == UpdateStockType.add.rawValue ? .primaryBlue : .redColor
    }

    func registerEvents(uiModel: IStockDetailInfoTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }
    }
}
