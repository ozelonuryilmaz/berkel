//
//  ArchiveListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 26.10.2023.
//

import UIKit

protocol ArchiveListTableViewCellOutputDelegate: AnyObject {

    func cellTapped(uiModel: IArchiveListTableViewCellUIModel)
}

class ArchiveListTableViewCell: BaseTableViewCell {

    weak var outputDelegate: ArchiveListTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: UIView!

    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblProduct: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCell(with uiModel: IArchiveListTableViewCellUIModel) {
        registerEvents(uiModel: uiModel)

        lblDate.text = uiModel.date
        lblProduct.text = uiModel.productName
        lblDesc.text = uiModel.desc
    }

    func registerEvents(uiModel: IArchiveListTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }
    }
}
