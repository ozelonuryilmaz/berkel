//
//  SeasonsTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 25.09.2023.
//

import UIKit

class SeasonsTableViewCell: BaseTableViewCell {

    @IBOutlet private weak var lblSeason: UILabel!
    @IBOutlet private weak var mContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }


    func configureCell(with uiModel: SeasonsTableViewCellUIModel) {
        lblSeason.text = uiModel.season
    }
}
