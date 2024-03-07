//
//  SettingsHeaderCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 10.12.2023.
//

import UIKit
import SnapKit

class SettingsHeaderCell: BaseTableViewHeaderFooterView {

    static let defaultHeight: CGFloat = SectionTitleView.defaultHeight

    override func initializeView() {
        setupAllConstraints()
    }

    func configureCell(with uiModel: SettingsSectionUIModel) {
        headerTitleView.text = uiModel.sectionTitle
    }

    // MARK: Component Definitions
    private lazy var headerTitleView: SectionTitleView = {
        let titleView = SectionTitleView()

        addSubview(titleView)
        return titleView
    }()
}

// MARK: UI
extension SettingsHeaderCell {

    func setupAllConstraints() {
        headerTitleView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.height.equalTo(SectionTitleView.defaultHeight)
        }
    }
}
