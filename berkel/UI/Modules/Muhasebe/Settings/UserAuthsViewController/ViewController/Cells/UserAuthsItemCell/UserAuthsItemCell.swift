//
//  UserAuthsItemCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.01.2024.
//

import UIKit

protocol UserAuthsItemCellOutputDelegate: AnyObject {
    func switchButtonTap(userModel: UserModel)
}

class UserAuthsItemCell: BaseTableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var mContentView: ShadowView!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelEmail: UILabel!
    @IBOutlet private weak var switchRole: UIButton!

    // MARK: Definitions
    weak var outputDelegate: UserAuthsItemCellOutputDelegate? = nil

    func configureCell(with uiModel: UserAuthsRowModel) {
        registerEvents(uiModel: uiModel)

        labelName.text = uiModel.userModel.name + " \(uiModel.isAdmin ? "✓" : "")"
        labelEmail.text = uiModel.userModel.email
        switchRole.setTitle(uiModel.isAdmin ? "-" : "+", for: .normal)
        mContentView.alpha = uiModel.isAdmin ? 1 : 0.4
    }

    private func registerEvents(uiModel: UserAuthsRowModel) {

        switchRole.onTap { [unowned self] _ in
            var userModel = uiModel.userModel
            userModel.isAdmin = !uiModel.isAdmin
            self.outputDelegate?.switchButtonTap(userModel: userModel)
        }
    }
}
