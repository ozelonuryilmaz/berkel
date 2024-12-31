//
//  SettingsFooterCell.swift
//  berkel
//
//  Created by Onur Yilmaz on 11.12.2023.
//

import UIKit
import SnapKit

class SettingsFooterCell: BaseTableViewHeaderFooterView {

    static let defaultHeight: CGFloat = 76

    // MARK: Definitions
    override func initializeView() {
        setupAllConstraints()
        setTitleLabelVersion()

    }

    private lazy var labelVersion: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .primaryDarkGray
        label.text = ""

        addSubview(label)
        return label
    }()
}

// MARK: UI
extension SettingsFooterCell {

    func setupAllConstraints() {
        // Version Label
        labelVersion.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().inset(16)
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().offset(8)
        }
    }
}

extension SettingsFooterCell {
    private func setTitleLabelVersion() {
        labelVersion.text = """
Copyright © 2025 by Onur Yılmaz
All rights reserved.
"""
    }
}
