//
//  CavusListTableViewCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 2.11.2023.
//

import UIKit

protocol CavusListTableViewCellOutputDelegate: AnyObject {
    func cellTapped(uiModel: ICavusListTableViewCellUIModel)
    func phoneNumberTapped(phoneNumber: String)
    func archiveTapped(cavusId: String)
    func updateTapped(uiModel: ICavusListTableViewCellUIModel)
}

class CavusListTableViewCell: BaseTableViewCell {

    weak var outputDelegate: CavusListTableViewCellOutputDelegate? = nil

    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var btnCall: UIButton!
    @IBOutlet private weak var btnArshive: UIButton!
    @IBOutlet private weak var btnUpdate: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        mContentView.roundCornersEachCorner(.allCorners, radius: 8)
    }

    func configureCellWith(uiModel: ICavusListTableViewCellUIModel) {
        self.registerEvents(uiModel: uiModel)

        self.lblName.text = uiModel.name
        self.lblDesc.text = uiModel.desc ?? ""
        //self.btnCall.setTitle(uiModel.phoneNumber, for: .normal)
    }

    func registerEvents(uiModel: ICavusListTableViewCellUIModel) {

        // Events
        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.cellTapped(uiModel: uiModel)
        }

        btnCall.onTap { [unowned self] _ in
            self.outputDelegate?.phoneNumberTapped(phoneNumber: uiModel.phoneNumber)
        }

        btnArshive.onTap { [unowned self] _ in
            self.outputDelegate?.archiveTapped(cavusId: uiModel.id ?? "")
        }

        btnUpdate.onTap { [unowned self] _ in
            self.outputDelegate?.updateTapped(uiModel: uiModel)
        }
    }
}
