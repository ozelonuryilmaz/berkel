//
//  SettingsItemCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.12.2023.
//

import UIKit

protocol SettingsItemCellOutputDelegate: AnyObject {
    func settingsCellTap(uiModel: SettingsItemCellUIModel)
}

class SettingsItemCell: BaseTableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var mContentView: UIView!
    @IBOutlet private weak var labelName: UILabel!

    // MARK: Definitions
    weak var outputDelegate: SettingsItemCellOutputDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(with uiModel: SettingsItemCellUIModel) {
        registerEvents(uiModel: uiModel)

        labelName.text = uiModel.rowTitle
    }

    private func registerEvents(uiModel: SettingsItemCellUIModel) {

        mContentView.onTap { [unowned self] _ in
            self.outputDelegate?.settingsCellTap(uiModel: uiModel)
        }
    }
}
