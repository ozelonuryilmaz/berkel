//
//  JBCPriceItemCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 22.04.2024.
//

import UIKit

protocol JBCPriceItemCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: JBCPriceItemCellUIModel)
}

class JBCPriceItemCell: BaseTableViewCell {

    weak var outputDelegate: JBCPriceItemCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblPrice: UILabel!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: JBCPriceItemCellUIModel) {
        registerEvents(uiModel: uiModel)

        lblPrice.text = "\(uiModel.price) TL"
        lblDate.text = uiModel.date
        lblDesc.text = uiModel.desc
    }

    func registerEvents(uiModel: JBCPriceItemCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }
    }
}
