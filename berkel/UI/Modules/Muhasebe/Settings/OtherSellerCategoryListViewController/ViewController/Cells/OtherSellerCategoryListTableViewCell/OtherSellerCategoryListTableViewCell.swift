//
//  OtherSellerCategoryListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 21.01.2024.
//

import UIKit

class OtherSellerCategoryListTableViewCell: BaseTableViewCell {
    
    @IBOutlet private weak var lblCategory: UILabel!
    @IBOutlet private weak var mContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: OtherSellerCategoryListTableViewCellUIModel) {
        lblCategory.text = uiModel.otherSellerCategory.name
    }
}
