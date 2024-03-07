//
//  ProductListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 18.11.2023.
//

import UIKit

class ProductListTableViewCell: BaseTableViewCell {
    
    @IBOutlet private weak var lblProduct: UILabel!
    @IBOutlet private weak var mContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }


    func configureCell(with uiModel: ProductListTableViewCellUIModel) {
        lblProduct.text = uiModel.product.name
    }
    
}
